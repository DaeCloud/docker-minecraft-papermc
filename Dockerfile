FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /minecraft

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget curl gnupg build-essential && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install supervisor for managing processes
RUN apt-get install -y supervisor

# Set environment variables
ENV PAPER_VERSION=1.20.6 \
    PAPER_BUILD=147 \
    MEMORY_SIZE=4G \
    EULA=false

# Create the start script in the root directory
RUN echo '#!/bin/bash\n\
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

# Install MineOS
RUN git clone https://github.com/hexparrot/mineos-node.git /usr/games/minecraft && \
    cd /usr/games/minecraft && \
    npm install --unsafe-perm

# Configure supervisor
RUN echo '[supervisord]\n\
nodaemon=true\n\
\n\
[program:mineos]\n\
command=/usr/bin/node /usr/games/minecraft/webui.js\n\
directory=/usr/games/minecraft\n\
autostart=true\n\
autorestart=true\n\
\n\
[program:minecraft]\n\
command=/bin/sh /start.sh\n\
autostart=true\n\
autorestart=true' > /etc/supervisor/conf.d/supervisord.conf

# Expose necessary ports
EXPOSE 25565 8080

# Start supervisor to manage MineOS and Minecraft server
CMD ["/usr/bin/supervisord"]
