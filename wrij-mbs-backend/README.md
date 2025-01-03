# wij-mbs-backend
API server voor het WRIJ meetplan beheersysteem. De applicatie is gebouwd in typescript en maakt gebruik van ExpressJS webserver functionaliteit i.c.m. een postgress database.

# Running the app in Docker
Docker container aanmaken en starten met twee images: docker compose up
Images:
1) ExpressJS API-server
2) Postgress DB database server


# removing Docker container and images
docker compose down --rmi all

# Werking van Orders, Kosten en Ontdubbeling
	/* Vul ontdubbelingstabel met een record voor elke kostenregel die een lagere prioriteit heeft dan een andere kostenregel en 
		moet worden ontudubbeld. Het gaat om kostenregels met hetzelfde meetpakket, op hetzelfde meetpunt in hetzelfde jaar met een 
		lagere prioriteit of met gelijke prioriteit, maar met een hoger id (=later aangemaakt). 
		Kosten_related bevat het id van de kostenregel met een hogere prioriteit (=lagere prioriteit waarde), of gelijke prio en lager ID. 
		Aantal per maand bevat het aantal te minderen metingen voor deze kostenregel. De kolom per maand bevat het aantal ILOW punten of 
		euro's (afhankelijk van valuta) dat minder in rekening hoeft te worden gebracht voor deze regel.
	*/

- **tblOrders** bevat de orderregels met daarin per regel o.a. meetpakket, meetpunt (=locatie), meetplan, start- en eindjaar, alternatie, aantal metingen per maand)
- **tblOntdubbelregels** is een tabel die wordt gebruikt in een tussenstap om kosten te ontdubbelen. Tabel bevat een record voor elke kostenregel die een lagere prioriteit heeft dan een andere kostenregel en 
		moet worden ontudubbeld. Het gaat om kostenregels met hetzelfde meetpakket, op hetzelfde meetpunt in hetzelfde jaar met een 
		lagere prioriteit of met gelijke prioriteit, maar met een hoger id (=later aangemaakt). 
		Veld kosten_related bevat het id van de kostenregel met een hogere prioriteit (=lagere prioriteit waarde), of gelijke prio en lager ID. 
		Aantal per maand bevat het aantal te minderen metingen voor deze kostenregel. De kolom per maand bevat het aantal ILOW punten of 
		euro's (afhankelijk van valuta) dat minder in rekening hoeft te worden gebracht voor deze regel.
  



- **tblKostenregels** wordt gevuld door een database trigger en triggerfunctie (_OrderKosten_calc()_) op wijzigingen van tblOrders. Bij elke wijziging op tblOrders worden de regels in deze tabel

- **tblKosten**
