# Symfony Alpine Docker
A Dockerfile ready for Symfony built on Alpine Linux

## Bundle
- Alpine Linux 3.15 (2021-11-24)
- Apache/2.4.52 with mod_php (PHP 7.4.27) + OPcache
- Composer (latest)
- Symfony CLI (latest)

## Requirements

* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)

## Build

```bash
docker-compose up -d --build
```

## Symfony Installation

### Initialization

Connect to Docker container
```bash
docker-compose run --rm php /bin/sh
```

Check that container meets Symfony Requirements
```bash
symfony check:requirements
```

### Install

Run this if you are building a traditional web application
```
symfony new ./ --webapp
```

Run this if you are building a microservice, console application or API
```bash
symfony new ./
```

You can add  `--version` parameter to select desired version.<br>
Example: `lts`, `4.4` or `next` (version in active development)
```bash
symfony new ./ --version=5.4
```

Exit from container terminal by running `exit` command

### Speed Optimization

1) Open `docker-compose.yml` and uncomment 2 lines under `volumes:`
```
    volumes:
      - vendor-var-vol:/var/www/html/var
      - vendor-var-vol:/var/www/html/vendor
      - ./app:/var/www/html/
```
2) Delete `app/vendor` and  folder
3) Delete `app/var` folder
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

**Note:** You can configure port in `.env` file