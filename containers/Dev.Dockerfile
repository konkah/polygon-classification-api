FROM python:3.10-slim-bullseye

RUN apt update \
  && DEBIAN_FRONTEND=noninteractive apt install -y \
    net-tools \
    nano \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

ENV PYTHONPATH /var/api

WORKDIR /var/api
COPY ./requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

ENTRYPOINT [ "uvicorn", "main:app", "--host", "0.0.0.0", "--reload" ]