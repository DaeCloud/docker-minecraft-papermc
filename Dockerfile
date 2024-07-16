FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /minecraft

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget unzip curl gnupg build-essential nginx && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PAPER_VERSION=1.20.6 \
    PAPER_BUILD=147 \
    MEMORY_SIZE=4G \
    EULA=false

# Create the start script in the root directory
RUN echo '#!/bin/bash\n\
    # Create plugins folder if it does not exist\n\
    mkdir -p /minecraft/plugins\n\
    \n\
    # Download WebConsole-2.5.jar if it does not exist in plugins folder\n\
    if [ ! -f /minecraft/plugins/WebConsole-2.5.jar ]; then\n\
    wget -O /minecraft/plugins/WebConsole-2.5.jar "https://github.com/mesacarlos/WebConsole/releases/download/v2.5/WebConsole-2.5.jar";\n\
    fi\n\
    \n\
    # Check if eula.txt exists\n\
    if [ ! -f /minecraft/eula.txt ]; then\n\
    # Check EULA environment variable and create eula.txt accordingly\n\
    if [ "$EULA" = "true" ]; then\n\
    echo "eula=true" > /minecraft/eula.txt\n\
    else\n\
    echo "eula=false" > /minecraft/eula.txt\n\
    fi\n\
    fi\n\
    \n\
    # Download Paper jar if it does not exist\n\
    if [ ! -f /minecraft/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar ]; then\n\
    wget -O /minecraft/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar "https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar";\n\
    fi\n\
    \n\
    # Start the Minecraft server\n\
    java -Xms${MEMORY_SIZE} -Xmx${MEMORY_SIZE} -jar /minecraft/paper-${PAPER_VERSION}-${PAPER_BUILD}.jar nogui' > /start.sh && \
    chmod +x /start.sh



RUN cd /var/www/html && \
    rm ./index.nginx-debian.html && \
    wget https://github.com/mesacarlos/WebConsole/releases/download/v2.5/client-v2.5.zip && \
    unzip client-v2.5.zip && \
    rm client-v2.5.zip && \
    cp -r ./client-v2.5/. . && \
    rm -R client-v2.5

# Expose necessary ports
EXPOSE 25565 80 8080

# Start nginx and Minecraft server
CMD sudo service nginx start && sh /start.sh
