FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /minecraft

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget unzip curl gnupg build-essential rdiff-backup screen && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

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

# Install McMyAdmin
WORKDIR /usr/local
RUN wget https://mcmyadmin.com/Downloads/etc.zip && \
    unzip etc.zip && \
    rm etc.zip

# Switch to non-root user for McMyAdmin setup
USER nobody
RUN mkdir -p /McMyAdmin && \
    cd /McMyAdmin && \
    wget https://mcmyadmin.com/Downloads/MCMA2_glibc26_2.zip && \
    unzip MCMA2_glibc26_2.zip && \
    rm MCMA2_glibc26_2.zip && \
    ./MCMA2_Linux_x86_64 -setpass ${ADMIN_PASS} -configonly

# Expose McMyAdmin port
EXPOSE 8080 25565

# Start McMyAdmin
CMD ["sh", "-c", "cd /McMyAdmin; ./MCMA2_Linux_x86_64"]
