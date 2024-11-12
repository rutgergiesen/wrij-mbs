# wij-mbs-backend
API server voor het WRIJ meetplan beheersysteem. De applicatie is gebouwd in typescript en maakt gebruik van ExpressJS webserver functionaliteit i.c.m. een postgress database.

# Running the app in Docker
Docker container aanmaken en starten met twee images: docker compose up
Images:
1) ExpressJS API-server
2) Postgress DB database server


# removing Docker container and images
docker compose down --rmi all
