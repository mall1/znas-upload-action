# Dockerfile for GitHub Docker Action
FROM node:22-slim

# Install dependencies
RUN apt-get update && apt-get install -y zip git && rm -rf /var/lib/apt/lists/*

# Copy the action repository
COPY ./app /app
WORKDIR /app

# Ensure entrypoint.sh has executable permissions
RUN chmod +x /app/entrypoint.sh

# Install Node.js dependencies
RUN npm install puppeteer --unsafe-perm=true --allow-root

# Entrypoint for the action
ENTRYPOINT ["/app/entrypoint.sh"]
