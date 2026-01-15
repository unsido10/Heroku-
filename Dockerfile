FROM python:3.10

# Настройки среды
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DOCKER=true \
    GIT_PYTHON_REFRESH=quiet

# Установка системных пакетов. 
# Мы убрали 'sed' и 'upgrade'. Только чистая установка.
RUN apt-get update && apt-get install --no-install-recommends -y \
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
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /data

# Клонируем бота во временную папку и переносим содержимое
RUN git clone https://github.com/coddrago/Heroku /data/Heroku
WORKDIR /data/Heroku

# Установка зависимостей самого юзербота
RUN pip install --no-cache-dir -U -r requirements.txt

# Открываем порт
EXPOSE 8080

# Команда запуска
CMD ["python3", "-m", "heroku"]
