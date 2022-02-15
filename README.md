# Symfony Alpine Docker
A Dockerfile with Alpine Linux that is ready for Symfony Application

## Bundle
- Alpine Linux 3.15
- Apache/2.4.52 with mod_php
- PHP 7.4.27 with OPcache
- Node.js 16.x LTS
- Composer (latest)
- Symfony CLI (latest)

## Requirements

* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)

## Configuration

You can open `.env` file to configure the following things
* NodeJS package manager `yarn` or `npm`
```bash
NODEJS_PACKAGE_MANAGER=yarn
```
* Default Apache port for your application
```bash
APACHE_SYSTEM_PORT=8080
```

## Build

```bash
docker-compose up -d --build
```

## Symfony Installation

### Initialization

1) Connect to Docker container
```bash
docker-compose run --rm php /bin/sh
```

2) Check that container meets Symfony Requirements
```bash
symfony check:requirements
```

### Install

1) Select configuration and execute command
* Run this if you are building a traditional web application
```
symfony new ./ --webapp
```

* Run this if you are building a microservice, console application or API
```bash
symfony new ./
```

* Run this if you want to install specific version by providing `--version` parameter.<br>
Example: `lts`, `4.4` or `next` (version in active development)
```bash
symfony new ./ --version=5.4
```

2) Exit from container terminal by executing `exit` command

### Speed Optimization

1) Open `docker-compose.yml` and uncomment 2 lines under `volumes:`
```
    volumes:
      - vendor-var-vol:/var/www/html/var
      - vendor-var-vol:/var/www/html/vendor
      - ./app:/var/www/html/
```
2) Delete `app/var` and  folder
3) Delete `app/vendor` folder
4) Rebuild Docker Container
```bash
docker-compose up -d --build
```
4) Reinstall Composer dependencies
```bash
docker-compose run --rm php composer install
```

### Usage

Open http://localhost:8080

**Note:** You can configure host port in `.env` file
