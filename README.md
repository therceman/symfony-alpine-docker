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
* NodeJS package manager `yarn` (default) or `npm`. <br>
 [NPM vs. Yarn: Which Package Manager Should You Choose?](https://www.whitesourcesoftware.com/free-developer-tools/blog/npm-vs-yarn-which-should-you-choose/)
```bash
NODEJS_PACKAGE_MANAGER=yarn
```
* Default Apache port for your application
```bash
APACHE_SYSTEM_PORT=8080
```

## Setup

### Initialization
1) Build and run Docker container
```bash
docker-compose up -d --build
```
2) Connect to Docker container
```bash
docker-compose run --rm app /bin/sh
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

**Note:** You can configure host port in `.env` file
