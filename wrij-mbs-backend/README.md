# wij-mbs-backend
API server voor het WRIJ meetplan beheersysteem. De applicatie is gebouwd in typescript en maakt gebruik van ExpressJS webserver functionaliteit i.c.m. een postgress database.

# Running the app in Docker
Docker container aanmaken en starten met twee images: docker compose up
Images:
1) ExpressJS API-server
2) Postgress DB database server


# removing Docker container and images
docker compose down --rmi all

# Orders, Kosten en Ontdubbeling
- **tblOrders** bevat de orders zoals door de gebruiker aangemaakt met daarin per regel o.a. meetpakket, meetpunt (=locatie), meetplan, start- en eindjaar, alternatie, aantal metingen per maand.
- **tblKosten** bevat de ontdubbeling, bruto (niet ontdubbelde), netto (ontdubbelde) aantallen en kosten per order per jaar met bijbehorende details (valuta, toegepaste ontsubbeling) en verwijzigingen naar relevante tabellen (meetpakket, order, meetplan, etc).

**Werking van orders, ontdubbeling en kosten**
Om kosten en ontdubbeling te berekenen wordt gebruik gemaakt van Postgres tabellen, triggers en triggerfuncties:
- **tblKostenregels** bevat de vertaling van orders (in tblOrders) naar te realiseren metingen en bijbehorende kosten. De tabel bevat alleen bruto aantal metingen en kosten, oftewel deze zijn niet ontdubbeld. Obv alternatie, start- en eindjaar wordt per jaar dat er gemeten moet worden (of monsternames) een regel aangemaakt met o.a. per maand het aantal metingen en de kosten.  Deze tabel wordt gevuld door een database trigger en triggerfunctie (_OrderKosten_calc()_) op wijzigingen van tblOrders. Bij elke wijziging op tblOrders worden regels in deze tabel overeenkomstig verwijderd en opnieuw aangemaakt.
- **tblOntdubbelregels** is een tabel die wordt gebruikt in een tussenstap om kosten te ontdubbelen. Deze tabel bevat een record voor elke kostenregel die een lagere prioriteit heeft dan een andere kostenregel en dus moet worden ontudubbeld, i.e. niet moet worden gemeten of in rekening moet worden gebracht. Het gaat om kostenregels met hetzelfde meetpakket, op hetzelfde meetpunt in hetzelfde jaar met een lagere prioriteit of met gelijke prioriteit, maar met een hoger id (=later aangemaakt). Veld kosten_related bevat het id van de kostenregel met een hogere prioriteit (=lagere prioriteit waarde), of gelijke prio en lager ID. Aantal per maand bevat het aantal te minderen metingen voor deze kostenregel. De kolom per maand bevat het aantal ILOW punten of euro's (afhankelijk van valuta) dat minder in rekening hoeft te worden gebracht voor deze regel. Deze tabel wordt als tussenstap gevuld door een database trigger en triggerfunctie (_Kosten_Ontdubbelen()_) op inserts en updates in tblKostenregels

Volgorde waarin de tabellen worden gevuld:
1. tblOrders (door gebruiker)
2. tblKostenregels (door triggers op tblOrders die functie _OrderKosten_calc()_ uitvoeren)
3. tblKosten (door triggers op tblKostenregels die functie _Kosten_Ontdubbelen()_ uitvoeren en daarbij in een tussenstap gebruik maakt van tblOntdubbelregels)
