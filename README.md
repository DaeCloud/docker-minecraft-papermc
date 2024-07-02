# Minecraft Paper Server Docker Container

This Docker container allows you to run a Minecraft Paper server with customizable settings. Paper is a high-performance fork of the Minecraft server that aims to fix gameplay and mechanics inconsistencies as well as optimize server performance.

## Features

- Easily customizable Paper server version and build
- Configurable memory allocation for the server
- Automatic acceptance of the Minecraft EULA
- Automatic downloading of the Paper server jar if it does not exist
- Persistent server data using Docker volumes

## Environment Variables

- `PAPER_VERSION` (default: `1.20.6`): Specifies the Minecraft version of Paper to download.
- `PAPER_BUILD` (default: `147`): Specifies the build number of the Paper server to download.
- `MEMORY_SIZE` (default: `4G`): Specifies the maximum and minimum amount of RAM the server can use.
- `EULA` (default: `false`): Automatically accepts the Minecraft EULA if set to true.

## Running the Container

To run the Minecraft Paper server Docker container with persistent data, use the following command:

```sh
docker run -d -p 25565:25565 \
    -v /path/on/host:/minecraft \
    -e PAPER_VERSION=1.20.6 \
    -e PAPER_BUILD=147 \
    -e MEMORY_SIZE=4G \
    -e EULA=true \
    daelinc/minecraft-papermc
```

## Customization

You can customize the server by providing different values for the environment variables when running the container. Here are the details:

### PAPER_VERSION

Specifies the Minecraft version of Paper to download. For example, 1.20.7.

### PAPER_BUILD

Specifies the build number of the Paper server to download. For example, 148.

### MEMORY_SIZE

Specifies the maximum and minimum amount of RAM the server can use. For example, 8G.

### EULA

Automatically accepts the Minecraft EULA if set to true. The server will not start unless the EULA is accepted. By default, it is set to false.
