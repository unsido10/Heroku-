FROM python:3.10 AS python-base
FROM python-base AS builder-base

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    AIOHTTP_NO_EXTENSIONS=1 \
    \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv" \
    \
    DOCKER=true \
    GIT_PYTHON_REFRESH=quiet

# Исправляем репозитории и устанавливаем пакеты (БЕЗ upgrade, чтобы не было ошибки 100)
RUN sed -i 's|http://deb.debian.org/debian|http://ftp.us.debian.org/debian|g' /etc/apt/sources.list && \
    apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    ffmpeg \
    gcc \
    git \
    libavcodec-dev \
    libavdevice-dev \
    libavformat-dev \
    libavutil-dev \
    libcairo2 \
    libmagic1 \
    libswscale-dev \
    openssl \
    wkhtmltopdf && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Установка Node.js
RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs && \
    rm nodesource_setup.sh

WORKDIR /data
RUN mkdir /data/private

# Клонируем и настраиваем бота
RUN git clone https://github.com/coddrago/Heroku /data/Heroku
WORKDIR /data/Heroku
RUN git fetch && git checkout master && git pull

# Устанавливаем зависимости Python
RUN pip install --no-warn-script-location --no-cache-dir -U -r requirements.txt

# Порт для Render
EXPOSE 8080

# Запуск бота
CMD ["python3", "-m", "heroku"]
