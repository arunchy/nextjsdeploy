# Stage 1: Install dependencies and build
FROM node:current-alpine3.22 AS builder

# Set working directory
WORKDIR /app

# Copy only package files first for better caching
COPY nextapp/package*.json ./nextapp/
RUN npm install --prefix ./nextapp

# Copy the rest of the application
COPY nextapp/ ./nextapp

# Build the app
RUN npm run build --prefix ./nextapp

# Stage 2: Run the app with Node.js
FROM node:current-alpine3.22

WORKDIR /app

# Copy built app from builder stage
COPY --from=builder /app/nextapp /app

# Expose the default Next.js port
EXPOSE 3000

# Start the Next.js server
CMD ["npm", "start"]
