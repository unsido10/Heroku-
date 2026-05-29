FROM python:3.10-slim AS python-base
ENV DOCKER=true
ENV GIT_PYTHON_REFRESH=quiet

ENV PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN apt update && apt install libcairo2 git build-essential -y --no-install-recommends
RUN rm -rf /var/lib/apt/lists /var/cache/apt/archives /tmp/*

RUN mkdir /data

COPY . /data/Heroku
WORKDIR /data/Heroku

RUN pip install --no-warn-script-location --no-cache-dir -U -r requirements.txt

# Обманка для Render: запускаем HTTP-сервер на выданном порту в фоне (&) и стартуем бота
CMD python3 -m http.server $PORT & python3 -m heroku --no-web --root
