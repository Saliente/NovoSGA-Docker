FROM php:latest
ARG uid=1000
ARG user=sammy
RUN apt-get update && apt-get install git curl zip unzip libpng php php-curl php-cli php-mbstring php-zip php-xml php-pdo php-mysql
RUN apt-get clean
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
WORKDIR /var/wwW
# PERMISSÃO
    #RUN chown www-data:www-data -R /var/www/
    #RUN useradd -G www-data,root -u $uid -d /home/$user $user
    #RUN mkdir -p /home/$user/.composer && \
    #    chown -R $user:$user /home/$user
#COMPOSER 
COPY --from=composer:1.7.0 /usr/bin/compose /usr/bin/compose
# VARIAVEL NOVOSGA
ENV APP_ENV=prod \
    LANGUAGE=pt_BR \
    NOVOSGA_ADMIN_USERNAME="admin" \
    NOVOSGA_ADMIN_PASSWORD="123456" \
    NOVOSGA_ADMIN_FIRSTNAME="Administrator" \
    NOVOSGA_ADMIN_LASTNAME="Global" \
    NOVOSGA_UNITY_NAME="My Unity" \
    NOVOSGA_UNITY_CODE="U01" \
    NOVOSGA_NOPRIORITY_NAME="Normal" \
    NOVOSGA_NOPRIORITY_DESCRIPTION="Normal service" \
    NOVOSGA_PRIORITY_NAME="Priority" \
    NOVOSGA_PRIORITY_DESCRIPTION="Priority service" \
    NOVOSGA_PLACE_NAME="Box"
    
#DEFININDO VERSÃO NOVOSGA
ENV NOVOSGA_VER=v2.1 \
    NOVOSGA_MD5=422be114d7bfc0949e972b1be769dbfb
#INSTALANDO NOVOSGA
ENV NOVOSGA_FILE=novosga.tar.gz \
    NOVOSGA_DIR=/var/www/html \
    NOVOSGA_URL=https://github.com/novosga/novosga/archive/${NOVOSGA_VER}.tar.gz \
    APP_ENV=prod \
    DATABASE_URL=mysql://127.0.0.1:3306/novosga?charset=utf8mb4&serverVersion=5.7

RUN set -xe \
    && mkdir -p $NOVOSGA_DIR && cd $NOVOSGA_DIR \
    && curl -fSL ${NOVOSGA_URL} -o ${NOVOSGA_FILE} \
    && echo "${NOVOSGA_MD5}  ${NOVOSGA_FILE}" | md5sum -c \
    && tar -xz --strip-components=1 -f ${NOVOSGA_FILE} \
    && rm ${NOVOSGA_FILE} \
    && composer install --no-dev -o
