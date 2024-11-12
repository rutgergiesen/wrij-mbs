### Backend API-server - starts here ###

# Installs Node.js image
FROM node:20.17.0

# sets the working directory for any RUN, CMD, COPY command
# all files we put in the Docker container running the server will be in /usr/src/app (e.g. /usr/src/app/package.json)
WORKDIR /
# Copies package.json, package-lock.json, tsconfig.json, .env to the root of WORKDIR
#COPY ["package.json", "tsconfig.json", ".env", "./"]

COPY package.json ./
COPY tsconfig.json ./

# Installs all packages
RUN npm install

ENV NODE_OPTIONS=--max-old-space-size=8192

# Copies everything in the src directory to WORKDIR/src
COPY . .

# Runs the dev npm script to build & start the server   
CMD npm run build && npm start

### Backend API-server - ende here ###


### Frontend server starts here
# STAGE 1: Build 
# FROM node:20.18-alpine AS build
# WORKDIR /usr/src/app
# COPY wrij-mbs-frontend/package.json wrij-mbs-frontend/package-lock.json ./
# RUN npm install
# COPY wrij-mbs-frontend/. .
# RUN npm run build

# #STAGE 2: Run
# FROM nginx:1.17.2-alpine
# COPY wrij-mbs-frontend/nginx.conf /etc/nginx/nginx.conf
# COPY --from=build /usr/src/app/dist/wrij-mbs /usr/share/nginx/html

### Frontend server ende here