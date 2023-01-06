FROM debian:bullseye-slim as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get upgrade -y

RUN apt-get install -y curl dirmngr apt-transport-https lsb-release ca-certificates

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt -y install nodejs

FROM base as build

RUN apt -y install gcc g++ make

WORKDIR /var/www

COPY . .

RUN npm install

RUN npm run 'build prod'

FROM base as backend

FROM base as frontend

COPY --from=build --chown=www-data:www-data /var/www/dist/* /var/www/html

EXPOSE 8080
EXPOSE 8443
