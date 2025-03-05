FROM python:3.9-alpine

LABEL maintainer="tw"
LABEL version="0.0.1"
LABEL description="Telegram Bot for ServerStatus"

# 安装 requests 库
RUN pip install --no-cache-dir requests

WORKDIR /app
COPY ./bot.py .
CMD [ "python", "./bot.py" ]

