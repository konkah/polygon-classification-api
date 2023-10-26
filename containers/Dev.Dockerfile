FROM python:3.10-slim-bullseye

RUN apt update \
  && DEBIAN_FRONTEND=noninteractive apt install -y \
    net-tools \
    nano \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

# Create python path to test see the api
ENV PYTHONPATH /var/api

WORKDIR /var/api
COPY ./requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Entrypoint start only when you start the machine
ENTRYPOINT [ "uvicorn", "main:app", "--host", "0.0.0.0", "--reload" ]