# Stage 1: Building the app
FROM node:16-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .

# Build your Next app
RUN npm run build

# Stage 2: Running the app
FROM node:16-alpine AS runner

WORKDIR /app

# Copy the build output to replace the default server
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

# Expose the port your app runs on
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "start"]
