## Frontend server starts here
# STAGE 1: Build 
FROM node:20.18-alpine AS build
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

#STAGE 2: Run
FROM nginx:1.17.2-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /usr/src/app/dist/wrij-mbs /usr/share/nginx/html

## Frontend server ende here