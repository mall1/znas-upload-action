
# Dockerfile for GitHub Docker Action
FROM node:16-slim

# Install dependencies
RUN apt-get update && apt-get install -y zip git && rm -rf /var/lib/apt/lists/*

# Copy the action repository
COPY . /app
WORKDIR /app

# Install Node.js dependencies
RUN npm install puppeteer --unsafe-perm=true --allow-root

# Entrypoint for the action
ENTRYPOINT ["/app/entrypoint.sh"]
