# Base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Prevent standalone Chromium installation (unnecessary for Pyppeteer)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Copy and install Python dependencies first to leverage layer caching
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install -y \
    libnss3 \
    libatk-bridge2.0-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    libgbm1 \
    libasound2 \
    libcurl4 \
    libpangocairo-1.0-0 \
    libcups2 \
    libdrm2 \
    libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*
    
# Install dependencies for Google Chrome and Pyppeteer
RUN apt-get update && apt-get install curl gnupg -y \
  && curl --location --silent https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install google-chrome-stable -y --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Copy the rest of the application code
COPY . /app

CMD ["/bin/bash"]