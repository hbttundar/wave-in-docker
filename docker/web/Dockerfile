FROM ubuntu:20.04

LABEL maintainer="Hosein Bagherzadegan Talkhouncheh"

WORKDIR /var/www/html

ARG APP_ENV
ARG PHP_VERSION
ARG INSTALL_XDEBUG
ARG DEFAULT_WEB_SERVER
# Configure non-root user.
ARG WWWGROUP
ARG WWWUSER

ENV APP_ENV=${APP_ENV}
ENV WWWGROUP=${WWWGROUP:-1000}
ENV WWWUSER=${WWWUSER:-1000}
ENV PHP_VERSION=${PHP_VERSION:-8.0}
ENV DEFAULT_WEB_SERVER=${DEFAULT_WEB_SERVER:-nginx}

RUN echo 'Your Current Environment IS :${APP_ENV}'

RUN groupadd --force -g $WWWGROUP wave_cms
RUN useradd -ms /bin/bash --no-user-group -g $WWWGROUP -u 1337 wave_cms
RUN usermod -a -G root wave_cms && usermod -a -G www-data wave_cms
#
# copy all files that we need
#
COPY ./msmtp/  /tmp/
COPY self-certificate/server.crt /etc/ssl/certs/server.crt
COPY self-certificate/server.key /etc/ssl/private/server.key
COPY ${PHP_VERSION}/php/php.ini /etc/php/8.0/cli/conf.d/99-wave.ini
COPY ${PHP_VERSION}/apache/supervisord.conf /tmp/config/supervisord_apache2.conf
COPY ${PHP_VERSION}/nginx/supervisord.conf /tmp/config/supervisord_nginx.conf


COPY ./${PHP_VERSION}/build.sh /tmp/
COPY scripts/wave/ /tmp/wave/
RUN chmod +x /tmp/build.sh && chmod +x /tmp/wave/permission.sh && chmod +x /tmp/wave/startup.sh
RUN bash /tmp/build.sh
#
# copy  web server configs
#
COPY ${PHP_VERSION}/apache/config/  /etc/apache2/
COPY ${PHP_VERSION}/nginx/config/  /etc/nginx

RUN update-ca-certificates
RUN setcap "cap_net_bind_service=+ep" /usr/bin/php${PHP_VERSION}

# set permissions
RUN sh /tmp/wave/permission.sh

EXPOSE 80 443

ENTRYPOINT ["start.sh"]
