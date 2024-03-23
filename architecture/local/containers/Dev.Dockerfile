FROM python:3.11-slim-bullseye
LABEL maintainer="Karlos Helton Braga <Konkah>"

RUN apt update \
  && DEBIAN_FRONTEND=noninteractive apt install -y \
    net-tools \
    nano \
    curl \
    unzip \
    libpq-dev \
    build-essential \
    libssl-dev \
    libffi-dev \
    libjpeg-dev \
    python3-dev \
    python3-pip \
    default-libmysqlclient-dev \
    pkg-config \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

RUN apt upgrade -y \
  && apt autoremove -y \
  && apt autoclean -y

# Create python path to test see the api
ENV PYTHONPATH /var/api

WORKDIR /var/api
RUN pip install --upgrade pip
RUN pip install setuptools wheel pip-tools
COPY ./requirements.in requirements.in
RUN pip-compile --upgrade requirements.in
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Entrypoint start only when you start the machine
ENTRYPOINT [ "uvicorn", "main:app", "--host", "0.0.0.0", "--reload" ]