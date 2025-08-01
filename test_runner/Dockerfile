ARG DOCKER_REGISTRY_URL
ARG BASE_IMAGE
ARG BASE_TAG

FROM ${DOCKER_REGISTRY_URL}/${BASE_IMAGE}:${BASE_TAG}
ARG BASE_TAG

# 1. Установка системных зависимостей
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. Подготовка каталогов для OneScript
RUN mkdir -p /opt/oscript/bin && \
    chmod -R 755 /opt/oscript

# 3. Установка OneScript
RUN curl -fL -o /tmp/oscript.deb https://oscript.io/downloads/latest/deb && \
    dpkg -i /tmp/oscript.deb || (apt-get update && apt-get install -fy) && \
    cp /usr/bin/oscript /opt/oscript/bin/ && \
    cp /usr/bin/opm /opt/oscript/bin/ && \
    rm -f /tmp/oscript.deb && \
    test -f /opt/oscript/bin/oscript && \
    test -f /opt/oscript/bin/opm

# 4. Настройка окружения
ENV OSCRIPTPATH=/opt/oscript \
    OSCRIPTBIN=/opt/oscript/bin \
    PATH="/opt/oscript/bin:/opt/1cv8/x86_64/${BASE_TAG}:${PATH}"

# 5. Установка пакетов OneScript (с обработкой ошибок)
RUN /opt/oscript/bin/opm install vanessa-runner add || \
    (echo "First attempt failed, retrying..." && \
     sleep 5 && \
     /opt/oscript/bin/opm install vanessa-runner add) && \
    /opt/oscript/bin/opm list | grep -q vanessa-runner && \
    /opt/oscript/bin/opm list | grep -q add

# 6. Фиксация прав (без избыточного создания каталогов)
RUN chmod -R 755 /opt/oscript 2>/dev/null || true