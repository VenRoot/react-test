# Stage 1: Build the React Vite project
FROM node:22-alpine AS builder

# Set working directory inside the container
WORKDIR /app

# Install TypeScript globally
RUN npm i -g typescript

# Copy only package.json and package-lock.json first to leverage Docker cache
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the Vite project
RUN npm run build

# Stage 2: Serve the static files using a lightweight web server
FROM nginx:alpine

# Copy the built files from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
