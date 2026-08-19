# --- Build Stage ---
FROM node:18-alpine AS builder

WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci --only=production

# --- Production Stage ---
FROM node:18-alpine

WORKDIR /usr/src/app

# Set production environment
ENV NODE_ENV=production
ENV PORT=3000

# Copy built node_modules and code from builder
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY package*.json ./
COPY server.js ./
COPY public/ ./public/

# Run the app as a non-root user for security
USER node

EXPOSE 3000

CMD ["node", "server.js"]
