ARG DOCKER_REGISTRY_URL
ARG BASE_IMAGE
ARG BASE_TAG

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG}
ARG BASE_TAG

# Установка базовых зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    git \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Установка OneScript (без Mono)
RUN curl -fL -o /tmp/oscript.deb https://oscript.io/downloads/latest/deb && \
    dpkg -i /tmp/oscript.deb || (apt-get update && apt-get install -fy) && \
    rm -f /tmp/oscript.deb

# Подготовка каталогов
RUN mkdir -p /opt/oscript/bin && \
    chmod -R 755 /opt/oscript && \
    cp /usr/bin/oscript /opt/oscript/bin/ && \
    cp /usr/bin/opm /opt/oscript/bin/

# Настройка окружения
ENV OSCRIPTPATH=/opt/oscript \
    OSCRIPTBIN=/opt/oscript/bin \
    PATH="/opt/oscript/bin:/opt/1cv8/x86_64/${BASE_TAG}:${PATH}"

# Установка пакетов OneScript
RUN opm install vanessa-runner add