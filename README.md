# Docker Image Builder

This project contains a script for building Docker images in parallel using GNU `parallel`. The script finds all Dockerfiles in the project, builds a Docker image for each one, and tags the image with the DockerHub username and the relative path of the Dockerfile.

## Prerequisites

- Docker
- GNU `parallel`.

## Installation

1. Install Docker: Follow the instructions on the [official Docker website](https://docs.docker.com/get-docker/).
2. Install GNU `parallel`: On Ubuntu, you can install it with `sudo apt-get install parallel`.

## Usage

1. Set your Docker Hub username in the `build.sh` script.
2. Run the `build.sh` script with `bash build.sh`.

The script will find all Dockerfiles in the project, build a Docker image for each one, and tag the image with the DockerHub username and the relative path of the Dockerfile. The script uses GNU `parallel` to build the images in parallel.

The `build.sh` script is configured to fail fast, meaning it will stop as soon as one job fails.

## CircleCI Integration

This project is configured to use CircleCI for continuous integration. The CircleCI configuration is located in `.circleci/config.yml`.

The CircleCI job checks out the project code, installs the `parallel` command, and runs the `build.sh` script.

## Directory Structure and Image Tagging

The script tags the Docker images with the DockerHub username and the relative path of the Dockerfile. For example, if the DockerHub username is `myusername` and the Dockerfile is located at `php/8.2/browsers/Dockerfile`, the image will be tagged as `myusername/php:8.2-browsers`.

See the `build.sh` script for more details.
