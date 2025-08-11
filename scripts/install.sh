#!/bin/bash

# Получаем номер релиза из версии (третье число в версии, например из 8.3.20.1234 получаем 20)
ONEC_RELEASE=`echo $ONEC_VERSION | cut -d . -f 3`
echo "Release: "$ONEC_RELEASE
nls_install="ru"  # По умолчанию устанавливаем только русскую локализацию

# Для версий ниже 8.3.20 используется установка через deb-пакеты
if [[ "$ONEC_RELEASE" -lt "20" ]]; then
    case "$installer_type" in
      server)
          # Установка 64-битного сервера
          if [ "$nls" = true ]; then \
            dpkg -i 1c-enterprise*-{common,server}*.deb; \  # Установка с поддержкой всех языков
          else \
            dpkg -i 1c-enterprise*-{common,server}_*.deb; \  # Установка только с русским языком
          fi
          ;;
      server32)
          # Установка 32-битного сервера
          if [ "$nls" = true ]; then \
            dpkg -i 1c-enterprise*-{common,server,ws,crs}*.deb; \
          else \
            dpkg -i 1c-enterprise*-{common,server,ws,crs}_*.deb; \
          fi
          ;;
      client)
          # Установка 64-битного клиента
          if [ "$nls" = true ]; then \
            dpkg -i 1c-enterprise*-{common,server}_*.deb; \
            dpkg -i 1c-enterprise*-{common,client}*.deb; \
          else \
            dpkg -i 1c-enterprise*-{common,server,client}_*.deb; \
          fi
          ;;
      client32)
          # Заглушка для 32-битного клиента (не реализовано)
          ;;
      thin-client)
          # Установка тонкого клиента
          if [ "$nls" = true ]; then \
            dpkg -i 1c-enterprise83-thin-client*.deb; \
          else \
            dpkg -i 1c-enterprise83-thin-client_*.deb; \
          fi
          ;;
      thin-client32)
          # Скачивание и установка 32-битного тонкого клиента
          curl --fail -b /tmp/cookies.txt -o thin-client32.tar.gz -L "$THINCLIENT32LINK"
    esac
else
    # Для версий 8.3.20 и выше используется установка через run-скрипты
    if [ "$nls" = true ]; then 
      # Если нужна мультиязычная поддержка
      nls_install="az,ar,hy,bg,hu,el,vi,ka,kk,zh,it,es,lv,lt,de,pl,ro,ru,tr,tk,fr,uk"
    else
      # Только русский язык
      nls_install="ru"
    fi
    
    case "$installer_type" in
      server)
          # Установка 64-битного сервера через инсталлятор
          set -x  # Включение отладки
          echo $nls_install
          ./setup-full-${ONEC_VERSION}-x86_64.run --mode unattended --enable-components server,ws,$nls_install
          ;;
      server32)
          # Установка 32-битного сервера
          ./setup-full-${ONEC_VERSION}-i386.run --mode unattended --enable-components server,ws,config_storage_server,$nls_install
          ;;
      client)
          # Установка 64-битного клиента
          ./setup-full-${ONEC_VERSION}-x86_64.run --mode unattended --enable-components server,client_full,$nls_install
          ;;
      client32)
          # Установка 32-битного клиента
          ./setup-full-${ONEC_VERSION}-i386.run --mode unattended --enable-components server,client_full,$nls_install
          ;;
      thin-client)
          # Установка тонкого клиента (только русская версия)
          ./setup-thin-${ONEC_VERSION}-x86_64.run --mode unattended --enable-components ru
          ;;
      thin-client32)
          # Установка 32-битного тонкого клиента (только русская версия)
          ./setup-thin-${ONEC_VERSION}-i386.run --mode unattended --enable-components ru
          ;;
    esac
fi