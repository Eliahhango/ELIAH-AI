FROM node:lts-buster

RUN apt-get update && \
  apt-get install -y \
  ffmpeg \
  imagemagick \
  webp && \
  apt-get upgrade -y && \
  npm i pm2 -g && \
  rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the entire project context (including temp_repo) into the container
COPY . .

# Set the working directory to the cloned repo
WORKDIR /app/temp_repo

# Copy package.json from the cloned repo context
# (Note: This assumes package.json exists in temp_repo locally)
COPY package.json .

# Install dependencies inside temp_repo
RUN npm install --legacy-peer-deps

# If pm2 is not strictly needed, the global install above and this might be removable
# RUN npm install pm2 -g  # Redundant? pm2 is installed globally earlier

EXPOSE 5000

# Run the bot directly using node from within the temp_repo directory
CMD ["node", "ibrahim.js"]
