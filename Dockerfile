# Stage 1: Building the app
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# Stage 2: Running the app
FROM node:20-alpine AS runner

WORKDIR /app

# Copy only production dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy the build output
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["npm", "start"]
