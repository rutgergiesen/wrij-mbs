### Backend API-server - starts here ###

# Installs Node.js image
FROM node:20.17.0

# sets the working directory for any RUN, CMD, COPY command
# all files we put in the Docker container running the server will be in /usr/src/app (e.g. /usr/src/app/package.json)
WORKDIR /usr/src/app
# Copies package.json, package-lock.json, tsconfig.json, .env to the root of WORKDIR
#COPY ["package.json", "tsconfig.json", ".env", "./"]

COPY package.json ./
COPY tsconfig.json ./

# Installs all packages
RUN npm install
RUN npm install -g db-migrate

ENV NODE_OPTIONS=--max-old-space-size=8192

# Copies everything in the src directory to WORKDIR/src
COPY . .

# Runs the dev npm script to build & start the server
CMD npm run build && npm start



### Backend API-server - ende here ###