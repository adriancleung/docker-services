# docker-services
CLI tool to orchestrate my docker services. This repository hold all my current running services using Docker.

## File Naming Format
Create a Docker Compose file with the name `docker-compose.SERVICE_NAME.yml` where `SERVICE_NAME` is the name of the service you would like to create in the `./services/` directory. `docker-compose.TEMPLATE.yml` is a template file that can be used to create the Docker Compose file.

## CLI Usage
The CLI tool can be used to create and start containers, stop and remove containers, networks, images, and volumes, or restart services. Specify a Docker Compose file to target a specific service or use `all` to target all services in the `./services/` directory.

```
Usage: docker-services.sh [all | FILENAME] [COMMAND]
  FILENAME: should be in the format docker-compose.SERVICE_NAME.yml

Commands:
  up          Create and start containers
  down        Stop and remove containers, networks, images, and volumes
  restart     Restart services
```
