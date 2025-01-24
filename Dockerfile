FROM python:alpine

LABEL maintainer="lidalao"
LABEL version="0.0.1"
LABEL description="Telegram Bot for ServerStatus"

WORKDIR /app
RUN pip install requests
COPY ./bot.py .
CMD [ "python", "./bot.py" ]
