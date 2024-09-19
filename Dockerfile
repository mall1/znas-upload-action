# Dockerfile for GitHub Docker Action
FROM node:22-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    zip \
    git \
    curl \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    wget \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install Chromium for Puppeteer
RUN apt-get update && apt-get install -y chromium && rm -rf /var/lib/apt/lists/*

# Set up Puppeteer environment variables to use installed Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Copy the action repository
COPY ./app /app
WORKDIR /app

# Ensure entrypoint.sh has executable permissions
RUN chmod +x /app/entrypoint.sh

# Install Node.js dependencies
RUN npm install puppeteer --unsafe-perm=true --allow-root

# Entrypoint for the action
ENTRYPOINT ["/app/entrypoint.sh"]
