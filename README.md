# Symfony Alpine Docker
Dockerfile based on Alpine Linux ready for Symfony Application

## Dockerfile Bundle
- Alpine Linux 3.15
- Apache/2.4.52 with mod_php
- PHP 7.4.27 with OPcache
- Node.js 16.x LTS
- Composer (latest)
- Symfony CLI (latest)

## Docker Services
- app - Symfony Container
- pdb - PostgreSQL Database Container

## Requirements

* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)

## Clone

```bash
git clone https://github.com/therceman/symfony-alpine-docker.git
```

## Configuration

You can open `.env` file to configure the following things
* PHP OPCache timestamps validation.<br>
This should be turned off for production instances.
```bash
PHP_OPCACHE_VALIDATE_TIMESTAMPS=1
```
* NodeJS package manager: yarn or npm.<br>
 [NPM vs. Yarn: Which Package Manager Should You Choose?](https://www.whitesourcesoftware.com/free-developer-tools/blog/npm-vs-yarn-which-should-you-choose/)
```bash
NODEJS_PACKAGE_MANAGER=yarn
```
* Apache ports for your application.
```bash
APACHE_EXT_PORT=8080
APACHE_PORT=80
```
* PHP AMQP extension for message queue (e.g. RabbitMQ).
```bash
AMQP_ENABLED=0
```
* PostgreSQL database container config.
```bash
DB_VERS=13
DB_HOST=db
DB_NAME=app
DB_USER=psql
DB_PASS=pass
DB_PORT=5432
DB_EXT_PORT=15432
```

## Setup

### Initialization
1) Build and run Docker container
```bash
docker-compose up -d --build
```
2) Connect to Docker container
```bash
docker-compose run --rm app bash
```

3) Check that Docker container meets Symfony requirements
```bash
symfony check:requirements
```

### Symfony Installation

4) Select configuration and execute one of the following commands
* Run this if you are building a traditional web application (full Symfony Package)
```
symfony new ./ --webapp
```

* Run this if you are building a microservice, console application or API
```bash
symfony new ./
```

* Run this if you want to install specific version using `--version` parameter.<br>
Example: `lts`, `4.4` or `next` (version in active development)
```bash
symfony new ./ --version=5.4
```

5) Exit from Docker container
```bash
exit
```

### Speed Optimization
You need to mount 3 folders as separate volumes in the Docker container.<br>
This will increase your App, Composer and Node.Js loading/installing speed.

6) Open `docker-compose.yml` and uncomment 3 lines under `volumes:`
```
    volumes:
      - var:/var/www/html/var
      - vendor:/var/www/html/vendor
      - node_modules:/var/www/html/node_modules
      - ./app:/var/www/html/
```
7) Delete `app/var` folder
8) Delete `app/vendor` folder
9) Reinstall Composer dependencies
```bash
docker-compose run --rm app composer install
```
10) Rebuild and rerun Docker container
```bash
docker-compose up -d --build
```

### PostgreSQL Database Connection Setup
Make sure you have ORM Pack and Maker bundle installed. <br>
These dependencies are installed in full Symfony Package by default.<br>

1) Install Maker Bundle
```bash
docker-compose run --rm app composer require --dev symfony/maker-bundle
```

2) Install ORM Pack
```bash
docker-compose run --rm app composer require symfony/orm-pack
```
**Note:** Hit `n` when asked about Docker config recipes

3) Open `app/.env` and replace DATABASE_URL with this:
```bash
DATABASE_URL="postgresql://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}?serverVersion=${DB_VERS}&charset=utf8"
```
4) Test Database Connection
```bash
docker-compose run --rm app symfony console dbal:run-sql 'SELECT * FROM pg_am'
```

### Extra Steps (only for full Symfony Package)
If you have installed full Symfony Package using cmd `symfony new ./ --webapp`<br>
You will need to install Node.js dependencies and build Webpack bundle.
1) Install Node.js dependencies using `yarn` or `npm` (if configured)
```bash
docker-compose run --rm app yarn install
```
2) Build Webpack bundle
```bash
docker-compose run --rm app yarn encore dev
```
**Note:** You can tell Webpack to watch for file changes and rebuild webpack on update
```bash
docker-compose run --rm app yarn encore dev --watch
```

## View Your App

Navigate to http://localhost:8080 to see your app

**Note:** You can configure Apache external host port in `.env` file

## Additional Commands

Show Apache Logs
```bash
docker app logs
```

Dump ENV vars
```bash
docker-compose run --rm app symfony console debug:container --env-vars
```

Reset DB
```bash
docker-compose run --rm app symfony console doctrine:database:drop --force
```

Create DB
```bash
docker-compose run --rm app symfony console doctrine:database:create
```

Stop Docker
```bash
docker-compose down --remove-orphans
```

Stop Docker & Remove Volumes
```bash
docker-compose down --remove-orphans --volumes
```