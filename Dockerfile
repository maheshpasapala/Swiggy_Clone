# Build stage
FROM node:18-alpine AS build
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies with legacy peer deps flag
RUN npm install --legacy-peer-deps

# Copy source code
COPY . .

# Increase Node memory for build
ENV NODE_OPTIONS="--max-old-space-size=3072"

# Build the React app
RUN npm run build

# Production stage
FROM nginx:1.27-alpine
WORKDIR /usr/share/nginx/html

# Copy built files from build stage
COPY --from=build /app/build .

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]