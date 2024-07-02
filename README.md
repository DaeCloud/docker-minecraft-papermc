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
docker run -d -p 25565:25565 -p 8080:8080 -p 80:80 \
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

## Web Console

This image automatically installs the WebConsole plugin which allows you to access the console for your server.

### Accessing the console

- Visit [http://localhost:80](http://localhost:80) on your computer(*or replace with the ip address of the server*) and click `Add new server`.
- Give the server any name you want
- Set the `IP or Domain` to the ip of the server (*or localhost*)
- Set the `Port` to the port used by the plugin (`8080` by default)
- Set the `Password` to the password required by the plugin (`mySecurePassword` by default)
- Click on `Add server`.
