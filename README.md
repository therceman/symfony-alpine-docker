# Symfony Alpine Docker
A Dockerfile ready for Symfony Installation built on Alpine Linux

## Bundle
- Alpine Linux 3.15 (2021-11-24)
- Apache/2.4.52 with mod_php (PHP 7.4.27) + OPcache
- Composer (latest)
- Symfony CLI (latest)

## Requirements

* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)

## Info & Configuration

Default web address is http://localhost:8080

You can configure port in `.env` file

## Build

* Build & Run Docker container
```bash
docker-compose up -d --build
```

## Symfony Installation

### Connect to container
```bash
docker-compose run --rm php /bin/sh
```

### Install Latest Version

Run this if you are building a traditional web application
```
symfony new ./ --webapp
```

Run this if you are building a microservice, console application or API
```bash
symfony new ./
```

#### Install Specific Symfony Version

Use the most recent LTS version
```bash
symfony new ./ --version=lts
```

Use the 'next' Symfony version to be released (still in development)
```bash
symfony new ./ --version=next
```

You can also select an exact specific Symfony version
```bash
symfony new ./ --version=4.4
```


