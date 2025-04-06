# Kube Tiny MC

An easy and lightweight toolkit for deploying Minecraft servers in Kubernetes clusters.

⚠️ **Note**: This project is intended small, temporary Minecraft servers to play with friends only, DO NOT USE IT IN PRODUCTION.

## Overview

Kube Tiny MC provides a simple way to:
- Build a Docker image containing Java and necessary Minecraft server files
- Push images to ttl.sh (a temporary public registry with 24h TTL)
- Deploy servers to Kubernetes using Helm charts
- Expose the server via NodePort service

## Prerequisites

- Docker installed locally
- Access to a Kubernetes cluster
- Helm v3
- Base Minecraft server files

## Quick Start

1. Place your Minecraft server files in the `./server` directory
   - Include only necessary files to keep the image size minimal
   - Don't forget to include `eula.txt` with accepted EULA and other files that make server to start correctly

2. Test locally:
    ```bash
    make container-build
    docker run --rm -it -p 25565:25565 kube-tiny-mc
    ```

3. Deploy to Kubernetes:
    ```bash
    make deploy NAME=craft-mine NAMESPACE=minecraft
    ```

## Configuration

You can customize the deployment using the following parameters in `make` command:
- `NAME`: Server deployment name
- `NAMESPACE`: Kubernetes namespace

This project is designed to be cloned locally and customized to your needs. Key customization points:

- **Container Image**: The entire process of preparing the base image is defined in `Containerfile`. Here you can:
  - Modify Java version (currently uses Java 17 Corretto)
  - Add additional runtimes or dependencies

- **Server Startup**: Server startup parameters can be configured in `server/start` shell script:
  - Currently uses simple `java -jar server.jar`
  - Can be modified to add Java tuning parameters and arguments

- **Kubernetes Deployment**: All Kubernetes-related configurations are in the `helm` directory:
  - Currently exposes server via NodePort service
  - Can be customized for different service types, resources, etc.

## How It Works

The project uses ttl.sh as a temporary container registry. This service:
- Is public and requires no authentication
- Automatically removes images after 24 hours
- Provides no listing capabilities for privacy

## Contributing

Feel free to open issues and pull requests in this repository.

## License

This project is open source. See the LICENSE file for more details.
