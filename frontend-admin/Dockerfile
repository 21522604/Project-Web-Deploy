# Use the official Node.js image as the base image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Run migration to built-in next/font
RUN npx @next/codemod@latest built-in-next-font . --force

# Install dependencies
RUN npm install

# Update browserslist database
RUN npx browserslist@latest --update-db

# Copy the rest of the application code to the working directory
COPY . .

# Ensure the file exists before build
RUN ls -la styles/

# Build the Next.js application
RUN npm run build

# Expose the port the app runs on
EXPOSE 3001

# Start the application
CMD ["npm", "start"]
