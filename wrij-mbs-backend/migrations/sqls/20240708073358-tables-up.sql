/* CREATE ALL TABLES */
CREATE TABLE tblMeetplannen (
    id SERIAL PRIMARY KEY, 
    naam VARCHAR(100), 
    behoefte text, 
    code VARCHAR(10), 
    contactpersoon VARCHAR(100), 
    opdrachtgever VARCHAR(100), 
    startjaar numeric(4), 
    eindjaar numeric(4), 
    type VARCHAR(8), 
    projectnr integer, 
    versie integer, 
    aqlcode VARCHAR(10), 
    status VARCHAR(10)
);

CREATE TABLE tblMeetpakketten (
    id SERIAL PRIMARY KEY, 
    naam VARCHAR(255), 
    omschrijving VARCHAR(255),
    type VARCHAR(14),
    valuta VARCHAR(4),
    stukprijs smallint
);

CREATE TABLE tblMeetpunten (
    id SERIAL PRIMARY KEY,
    code VARCHAR(10),
    naam VARCHAR(255),
    x integer,
    y integer,
    toelichting VARCHAR(255)
);

CREATE TABLE tblPrioriteiten (
    id SERIAL PRIMARY KEY,
    prioriteit numeric(2),
    titel VARCHAR(64),
    omschrijving VARCHAR(255),
	UNIQUE (titel)
);

CREATE TABLE tblOrders (
    id SERIAL PRIMARY KEY,
    meetplan integer references tblMeetplannen(id),
    meetpunt integer references tblMeetpunten(id),
    meetpakket integer references tblMeetpakketten(id),
    alternatie numeric(2),
    startjaar numeric(4),
	eindjaar numeric(4),
    prioriteit integer references tblPrioriteiten(id),
    jan smallint,
    feb smallint,
    mrt smallint,
    apr smallint,
    mei smallint,
    jun smallint,
    jul smallint,
    aug smallint,
    sep smallint,
    okt smallint,
    nov smallint,
    dec smallint,
    toelichting VARCHAR(500),
    valuta VARCHAR(4), 
    stukprijs smallint,
    orderprijs integer,
	CREATED TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tblKostenregels (
    id SERIAL PRIMARY KEY,
	"order" integer references tblOrders(id),
	meetplan integer references tblMeetplannen(id),
    meetpunt integer references tblMeetpunten(id),
    meetpakket integer references tblMeetpakketten(id),
    prioriteit integer references tblPrioriteiten(id),
	jaar numeric(4),
	valuta VARCHAR(4),
	stukprijs smallint,
    aantal_jan smallint,	
	jan smallint,
    aantal_feb smallint,
    feb smallint,
    aantal_mrt smallint,
    mrt smallint,
    aantal_apr smallint,
    apr smallint,
    aantal_mei smallint,
    mei smallint,
    aantal_jun smallint,
    jun smallint,
    aantal_jul smallint,
    jul smallint,
    aantal_aug smallint,
    aug smallint,
    aantal_sep smallint,
    sep smallint,
    aantal_okt smallint,
    okt smallint,
    aantal_nov smallint,
    nov smallint,
    aantal_dec smallint,
    dec smallint,
	orderprijs smallint,
	CREATED TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	LAST_MODIFIED TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	UNIQUE("order", jaar)
);



CREATE OR REPLACE FUNCTION Kostenregels_changed() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.last_modified := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;

-- Create a trigger to update the 'last_modified' timestamp
CREATE OR REPLACE TRIGGER Kostenregels_update
BEFORE UPDATE ON tblKostenregels
FOR EACH ROW
	EXECUTE PROCEDURE Kostenregels_changed();


CREATE TABLE tblOntdubbelregels(
    id SERIAL PRIMARY KEY,
    kostenregel integer references tblKostenregels(id),
    kostenregel_related integer references tblKostenregels(id),
    jaar numeric(4),
	meetplan integer references tblMeetplannen(id),
	"order" integer references tblOrders(id),
	order_related integer references tblOrders(id),
	meetpakket integer references tblMeetpakketten(id),
	meetpunt integer references tblMeetpunten(id),
	prioriteit integer references tblPrioriteiten(id),
	prioriteit_related integer references tblPrioriteiten(id),
    aantal_jan numeric(2),
	jan numeric(2),
    aantal_feb numeric(2),
	feb numeric(2),
    aantal_mrt numeric(2),
	mrt numeric(2),
    aantal_apr numeric(2),
	apr numeric(2),
	aantal_mei numeric(2),
    mei numeric(2),
	aantal_jun numeric(2),
    jun numeric(2),
	aantal_jul numeric(2),
    jul numeric(2),
	aantal_aug numeric(2),
    aug numeric(2),
	aantal_sep numeric(2),
    sep numeric(2),
	aantal_okt numeric(2),
    okt numeric(2),
	aantal_nov numeric(2),
    nov numeric(2),
	aantal_dec numeric(2),
    dec numeric(2),
	reden_ontdubbeling VARCHAR(255),
	UNIQUE(kostenregel, kostenregel_related)
);

CREATE TABLE tblKosten (
	id SERIAL PRIMARY KEY,
    "order" INT NOT NULL,
    meetplan integer references tblMeetplannen(id),
    meetpunt integer references tblMeetpunten(id),
    meetpakket integer references tblMeetpakketten(id),
    prioriteit integer references tblPrioriteiten(id),
	jaar numeric(4),
    valuta VARCHAR(10),
    stukprijs smallint,
    kostenregel integer references tblKostenregels,

	-- Per maand: aantal metingen (bruto-ontdubbeling=netto)
	-- Per maand: kosten (bruto-ontdubbeling=netto)
	aantal_jan_bruto smallint,
	aantal_jan_ontdubbeling smallint,
	aantal_jan_netto smallint,
	jan_bruto NUMERIC(4),
	jan_ontdubbeling NUMERIC(4),
	jan_netto NUMERIC(4),

	aantal_feb_bruto smallint,
	aantal_feb_ontdubbeling smallint,
	aantal_feb_netto smallint,
	feb_bruto NUMERIC(4),
	feb_ontdubbeling NUMERIC(4),
	feb_netto NUMERIC(4),

	aantal_mrt_bruto smallint,
	aantal_mrt_ontdubbeling smallint,
	aantal_mrt_netto smallint,
    mrt_bruto NUMERIC(4),	
    mrt_ontdubbeling NUMERIC(4),
    mrt_netto NUMERIC(4),

	aantal_apr_bruto smallint,
	aantal_apr_ontdubbeling smallint,
	aantal_apr_netto smallint,
   	apr_bruto NUMERIC(4),
    apr_ontdubbeling NUMERIC(4),
    apr_netto NUMERIC(4),

	aantal_mei_bruto smallint,
	aantal_mei_ontdubbeling smallint,    
	aantal_mei_netto smallint,
	mei_bruto NUMERIC(4),
    mei_ontdubbeling NUMERIC(4),
    mei_netto NUMERIC(4),

	aantal_jun_bruto smallint,
	aantal_jun_ontdubbeling smallint,  
	aantal_jun_netto smallint,
	jun_bruto NUMERIC(4),
    jun_ontdubbeling NUMERIC(4),	
    jun_netto NUMERIC(4),

	aantal_jul_bruto smallint,
	aantal_jul_ontdubbeling smallint,  
	aantal_jul_netto smallint,
	jul_bruto NUMERIC(4),
    jul_ontdubbeling NUMERIC(4),
    jul_netto NUMERIC(4),

	aantal_aug_bruto smallint,
	aantal_aug_ontdubbeling smallint,    
	aantal_aug_netto smallint,	
	aug_bruto NUMERIC(4),
    aug_ontdubbeling NUMERIC(4),
    aug_netto NUMERIC(4),

	aantal_sep_bruto smallint,
 	aantal_sep_ontdubbeling smallint,   
	aantal_sep_netto smallint,	
	sep_bruto NUMERIC(4),
    sep_ontdubbeling NUMERIC(4),
    sep_netto NUMERIC(4),

	aantal_okt_bruto smallint,
	aantal_okt_ontdubbeling smallint,    
	aantal_okt_netto smallint,	
	okt_bruto NUMERIC(4),
    okt_ontdubbeling NUMERIC(4),
    okt_netto NUMERIC(4),

	aantal_nov_bruto smallint,
	aantal_nov_ontdubbeling smallint,    
	aantal_nov_netto smallint,	
	nov_bruto NUMERIC(4),
    nov_ontdubbeling NUMERIC(4),
    nov_netto NUMERIC(4),

	aantal_dec_bruto smallint,
	aantal_dec_ontdubbeling smallint,    
	aantal_dec_netto smallint,	
	dec_bruto NUMERIC(4),
    dec_ontdubbeling NUMERIC(4),
    dec_netto NUMERIC(4),

	aantal_jaar_bruto smallint,
	aantal_jaar_ontdubbeling smallint,    
	aantal_jaar_netto smallint,	
	jaar_bruto NUMERIC(4),
    jaar_ontdubbeling NUMERIC(4),
    jaar_netto NUMERIC(4),
    -- Aggregated reasons for deduplication
    redenen_ontdubbeling TEXT
);

CREATE TABLE tblUsers (
	id SERIAL PRIMARY KEY,
	username VARCHAR(64) UNIQUE,
	password VARCHAR(64)
);


INSERT INTO tblPrioriteiten (prioriteit, titel, omschrijving)
 VALUES 
	(1, 'KRW', 'KRW gaat voor alles'), 
    (2, 'Project', 'Projecten hebben voorrang'), 
    (3, 'Overig', 'Overige zaken');


/* POPULATE TABLES */
INSERT INTO tblMeetplannen (
    naam, 
    behoefte,
    code,
    contactpersoon,
    opdrachtgever,
    startjaar,
    eindjaar,
    type,
    projectnr,
    versie,
    aqlcode,
    status
) 
VALUES (
	'Meetplan inzicht effect effluent RWZI',
	'Meer en beter inzicht krijgen van stoffen die van over de grens komen. Gelijktijdig een aantal aanvullingen om gerichter per waterlichaam een KRW oordeel te kunnen maken, in plaats van de huidige projectieregels toepassen.',
	null,
	'Stefan Witteveen',
	'Schoon en Gezond',
	2016,
	2028,
	'Routine',
	636201,
	1,
	'AQL345',
	'Concept'
),(
	'Meetplan inzicht effect effluent RWZI - Grenswater test',
	'Meer en beter inzicht krijgen van stoffen die van over de grens komen. Gelijktijdig een aantal aanvullingen om gerichter per waterlichaam een KRW oordeel te kunnen maken, in plaats van de huidige projectieregels toepassen.',
	null,
	'Stefan Witteveen',
	'Schoon en Gezond',
	2016,
	2028,
	'Routine',
	null,
	0,
	'',
	'Definitief'
),(
	'Meetnet Landbouwspeciek oppervlaktewater',
	'Meetnet bedoelt om te beoordelen of maatregelen in de landbouw effect hebben op de nutrientengehalten in het oppervlaktewater.',
	null,
	'Stefan Witteveen',
	'Schoon en Gezond',
	null,
	null,
	'Routine',
	null,
	0,
	null,
	'Definitief'
);

INSERT INTO tblMeetpunten (code, naam, x, y, toelichting)
VALUES (
	'AAB01',
	'Aaldersbeek Kerkpad Dinxperlo',
	231260,
	431708,
	null
),(
	'AAB02',
	'Aaldersbeek Terborgseweg Dinxperlo',
	230508,
	431616,
	null
),(
	'AAB03',
	'Stadswater Aaldersbeeklaan Dinxperlo',
	231215,
	431722,
	null
),(
	'AAG01',
	'Aaltens Goor Prinsendijk Aalten',
	234327,
	441949,
	null
)
,(
	'AAGPB01-1',
	'Aaltens Goor Goordijk Aalten peilbuis 1-1',
	234889,
	440763,
	null
);

/*INSERT INTO tblMeetpakketten 
	(id, naam, omschrijving, valuta, stukprijs) 
VALUES 
	(1, 'yow', 'omschrijving1', 'ILOW', 71),
	(2, 'yveld-chemie', 'omschrijving2', 'ILOW', 12),
	(3, 'licpow', 'omschrijving3', 'ILOW', 45),
	(4, 'licpow_nf', 'omschrijving4', 'EURO', 45),
	(5, 'monbeh', 'omschrijving5', 'ILOW', 8);
    */


-- Functie OrderKosten_calc maakt voor elk jaar dat er moet worden gemeten een kostenregel aan
CREATE OR REPLACE FUNCTION OrderKosten_calc() RETURNS TRIGGER AS $kostenCalc$
DECLARE 
	orderId integer = NEW.id;
	currJaar numeric(4);
	counter integer;
BEGIN
	-- -- Kostenregels en ontdubbeling voor deze order verwijderen
	-- -- Eerst de records in tblOntdubbelregels verwijderen die verwijzen naar kostenregel voor betreffende order id
	-- DELETE FROM tblOntdubbelregels WHERE id IN (
	-- 	-- verwijderen records in tblOntdubbelregels die verwijzen naar kostenregel voor betreffende order id
	-- 	SELECT KO.id
	-- 	FROM tblOntdubbelregels AS KO INNER JOIN tblKostenregels AS K ON K.id = KO.kostenregel
	-- 	WHERE K.order = orderId
	-- ) OR id IN (
	-- 	-- verwijderen records in tblOntdubbelregels die verwijzen naar kostenregel_related voor betreffende order id
	-- 	SELECT KO.id
	-- 	FROM tblOntdubbelregels AS KO INNER JOIN tblKostenregels AS K ON K.id = KO.kostenregel_related
	-- 	WHERE K.order = orderId	
	-- );

	-- Kostentabel leegmaken
	DELETE FROM tblKosten;
	-- Ontdubbelregels tabel leegmaken
	DELETE FROM tblOntdubbelregels;

	-- Dan evt bestaande kostenregels voor deze order verwijderen
	DELETE FROM tblKostenregels WHERE "order" = orderId;

	-- Tijdelijke tabel voor jaren waarin kosten worden gemaakt voor de betreffende order
	DROP TABLE IF EXISTS temp_tblJaren;
	CREATE TEMP TABLE temp_tblJaren (
		id SERIAL PRIMARY KEY,
		"order" integer,
		jaar numeric(4)
	);

	-- Tijdelijke tabel temp_tblJaren vullen met jaren waarin wordt gemeten voor deze order
	-- Jaren bepalen obv alternatie, start- en eindjaar. 
	counter = 0;
	currJaar = NEW.startjaar;
	FOR currJaar IN NEW.startjaar..NEW.eindjaar LOOP
		IF counter = NEW.alternatie OR currJaar = NEW.startjaar THEN 
			counter = 1;
			--RAISE NOTICE '%',currJaar;
			INSERT INTO temp_tblJaren ("order", jaar) VALUES (NEW.id, currJaar);
		ELSE
			counter = counter + 1;
		END IF;
			
	END LOOP;
		
	-- Kosten naar kostentabel laden, nog niet ontdubbeld
	EXECUTE 'INSERT INTO tblKostenregels(
		"order", meetplan, meetpunt, meetpakket, prioriteit, jaar, valuta,  stukprijs,
		aantal_jan, jan, aantal_feb, feb, aantal_mrt, mrt, aantal_apr, apr, aantal_mei, mei, aantal_jun, jun,
		aantal_jul, jul, aantal_aug, aug, aantal_sep, sep, aantal_okt, okt, aantal_nov, nov, aantal_dec, dec,
		orderprijs)
		SELECT 
			O.id, meetplan, meetpunt, meetpakket, prioriteit, J.jaar, valuta,  stukprijs, 
			jan, SUM(jan * stukprijs), feb, SUM(feb * stukprijs), mrt, SUM(mrt * stukprijs), apr, SUM(apr * stukprijs),
			mei, SUM(mei * stukprijs), jun, SUM(jun * stukprijs), jul, SUM(jul * stukprijs), aug, SUM(aug * stukprijs),
			sep, SUM(sep * stukprijs), okt, SUM(okt * stukprijs), nov, SUM(nov * stukprijs), dec, SUM(dec * stukprijs),
			SUM((jan + feb + mrt + apr + mei + jun + jul + aug + sep + okt + dec) * stukprijs) 
		FROM tblOrders AS O 
			INNER JOIN temp_tblJaren AS J ON O.id = J.order
		WHERE O.id = ' || orderId ||'
		GROUP BY O.id, valuta, stukprijs, J.jaar
		ORDER BY O.id, J.jaar, valuta';

	RETURN NULL;
END;
$kostenCalc$  LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER order_update
	AFTER INSERT OR UPDATE ON tblOrders
	FOR EACH ROW EXECUTE FUNCTION OrderKosten_calc();

CREATE OR REPLACE FUNCTION OrderKosten_Delete()
RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM tblKosten;
	DELETE FROM tblOntdubbelregels;
	DELETE FROM tblKostenregels WHERE "order" = OLD.id;

	RETURN OLD;
END; $$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER order_before_delete
	BEFORE DELETE ON tblOrders
	FOR EACH ROW EXECUTE FUNCTION OrderKosten_delete();

CREATE OR REPLACE FUNCTION Kosten_Ontdubbelen()
RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM tblKosten;
	DELETE FROM tblOntdubbelregels;

	/* Vul ontdubbelingstabel met een record voor elke kostenregel die een lagere prioriteit heeft dan een andere kostenregel en 
		moet worden ontudubbeld. Het gaat om kostenregels met hetzelfde meetpakket, op hetzelfde meetpunt in hetzelfde jaar met een 
		lagere prioriteit of met gelijke prioriteit, maar met een hoger id (=later aangemaakt). 
		Kosten_related bevat het id van de kostenregel met een hogere prioriteit (=lagere prioriteit waarde), of gelijke prio en lager ID. 
		Aantal per maand bevat het aantal te minderen metingen voor deze kostenregel. De kolom per maand bevat het aantal ILOW punten of 
		euro's (afhankelijk van valuta) dat minder in rekening hoeft te worden gebracht voor deze regel.
	*/
	INSERT INTO tblOntdubbelregels (kostenregel, kostenregel_related, jaar, meetplan, "order", order_related, meetpakket, meetpunt, prioriteit, prioriteit_related, 
		aantal_jan, jan, aantal_feb, feb, aantal_mrt, mrt, aantal_apr, apr, aantal_mei, mei, aantal_jun, jun, aantal_jul, jul, 
		aantal_aug, aug, aantal_sep, sep, aantal_okt, okt, aantal_nov, nov, aantal_dec, dec, reden_ontdubbeling)
	SELECT 
	    k1.id AS kostenregel_id,
	    k2.id AS related_kostenregel_id,
	    k1.jaar,
		k1.meetplan,
		k1.order,
		k2.order,
	    k1.meetpakket,
	    k1.meetpunt,
	    k1.prioriteit,
		k2.prioriteit,
		CASE 
	        WHEN k2.aantal_jan = 0 THEN 0
	        WHEN k1.aantal_jan > k2.aantal_jan THEN -k2.aantal_jan
	        ELSE -k1.aantal_jan
	    END AS aantal_jan,
	    CASE 
	        WHEN k2.jan = 0 THEN 0
	        WHEN k1.jan > k2.jan THEN -k2.jan
	        ELSE -k1.jan
	    END AS jan,
	    CASE 
	        WHEN k2.aantal_feb = 0 THEN 0
	        WHEN k1.aantal_feb > k2.aantal_feb THEN -k2.aantal_feb
	        ELSE -k1.aantal_feb
	    END AS aantal_feb,
		CASE 
	        WHEN k2.feb = 0 THEN 0
	        WHEN k1.feb > k2.feb THEN -k2.feb
	        ELSE -k1.feb
	    END AS feb,
	    CASE 
	        WHEN k2.aantal_mrt = 0 THEN 0
	        WHEN k1.aantal_mrt > k2.aantal_mrt THEN -k2.aantal_mrt
	        ELSE -k1.aantal_mrt
	    END AS aantal_mrt,
		CASE 
	        WHEN k2.mrt = 0 THEN 0
	        WHEN k1.mrt > k2.mrt THEN -k2.mrt
	        ELSE -k1.mrt
	    END AS mrt,
	    CASE 
	        WHEN k2.aantal_apr = 0 THEN 0
	        WHEN k1.aantal_apr > k2.aantal_apr THEN -k2.aantal_apr
	        ELSE -k1.aantal_apr
	    END AS aantal_apr,
		CASE 
	        WHEN k2.apr = 0 THEN 0
	        WHEN k1.apr > k2.apr THEN -k2.apr
	        ELSE -k1.apr
	    END AS apr,
	    CASE 
	        WHEN k2.aantal_mei = 0 THEN 0
	        WHEN k1.aantal_mei > k2.aantal_mei THEN -k2.aantal_mei
	        ELSE -k1.aantal_mei
	    END AS aantal_mei,
	    CASE 
	        WHEN k2.mei = 0 THEN 0
	        WHEN k1.mei > k2.mei THEN -k2.mei
	        ELSE -k1.mei
	    END AS mei,
	    CASE 
	        WHEN k2.aantal_jun = 0 THEN 0
	        WHEN k1.aantal_jun > k2.aantal_jun THEN -k2.aantal_jun
	        ELSE -k1.aantal_jun
	    END AS aantal_jun,
		CASE 
	        WHEN k2.jun = 0 THEN 0
	        WHEN k1.jun > k2.jun THEN -k2.jun
	        ELSE -k1.jun
	    END AS jun,
	    CASE 
	        WHEN k2.aantal_jul = 0 THEN 0
	        WHEN k1.aantal_jul > k2.aantal_jul THEN -k2.aantal_jul
	        ELSE -k1.aantal_jul
	    END AS aantal_jul,
		CASE 
	        WHEN k2.jul = 0 THEN 0
	        WHEN k1.jul > k2.jul THEN -k2.jul
	        ELSE -k1.jul
	    END AS jul,
	    CASE 
	        WHEN k2.aantal_aug = 0 THEN 0
	        WHEN k1.aantal_aug > k2.aantal_aug THEN -k2.aantal_aug
	        ELSE -k1.aantal_aug
	    END AS aantal_aug,
	    CASE 
	        WHEN k2.aug = 0 THEN 0
	        WHEN k1.aug > k2.aug THEN -k2.aug
	        ELSE -k1.aug
	    END AS aug,
	    CASE 
	        WHEN k2.aantal_sep = 0 THEN 0
	        WHEN k1.aantal_sep > k2.aantal_sep THEN -k2.aantal_sep
	        ELSE -k1.aantal_sep
	    END AS aantal_sep,
	    CASE 
	        WHEN k2.sep = 0 THEN 0
	        WHEN k1.sep > k2.sep THEN -k2.sep
	        ELSE -k1.sep
	    END AS sep,
	    CASE 
	        WHEN k2.aantal_okt = 0 THEN 0
	        WHEN k1.aantal_okt > k2.aantal_okt THEN -k2.aantal_okt
	        ELSE -k1.aantal_okt
	    END AS aantal_okt,
	    CASE 
	        WHEN k2.okt = 0 THEN 0
	        WHEN k1.okt > k2.okt THEN -k2.okt
	        ELSE -k1.okt
	    END AS okt,
	    CASE 
	        WHEN k2.aantal_nov = 0 THEN 0
	        WHEN k1.aantal_nov > k2.aantal_nov THEN -k2.aantal_nov
	        ELSE -k1.aantal_nov
	    END AS aantal_nov,
		CASE 
	        WHEN k2.nov = 0 THEN 0
	        WHEN k1.nov > k2.nov THEN -k2.nov
	        ELSE -k1.nov
	    END AS nov,
	    CASE 
	        WHEN k2.dec = 0 THEN 0
	        WHEN k1.dec > k2.dec THEN -k2.dec
	        ELSE -k1.dec
	    END AS dec,
	    CASE 
	        WHEN k2.aantal_dec = 0 THEN 0
	        WHEN k1.aantal_dec > k2.aantal_dec THEN -k2.aantal_dec
	        ELSE -k1.aantal_dec
	    END AS aantal_dec,
		CASE
			WHEN k1.prioriteit > k2.prioriteit THEN 'Lagere prioriteit ('|| k1.prioriteit || ') dan kostenregel ' || k2.id || ' (' || k2.prioriteit || ')'
			WHEN k1.prioriteit = k2.prioriteit THEN 'Gelijke prioriteit (' || k1.prioriteit || '). Kostenregel later aangemaakt dan kostenregel '|| k2.id ||' (order ' || k2.order || ')'
			ELSE 'REDEN ONBEKEND'
		END AS reden_ontdubbeling
	FROM 
	    tblKostenregels k1
	JOIN 
	    tblKostenregels k2
	ON 
	    k1.jaar = k2.jaar
	    AND k1.meetpakket = k2.meetpakket
	    AND k1.meetpunt = k2.meetpunt
	    AND (k1.prioriteit > k2.prioriteit
			OR (k1.prioriteit = k2.prioriteit AND k1.id > k2.id))
	ORDER BY jaar, k1.prioriteit, k2.prioriteit, k1.id DESC;

	/* toepassen van de ontdubbelregels op de kosten en 
	de kosten tabel vullen. Eerst tabel met ontdubbelde kosten leegmaken */
		DELETE FROM tblKosten;
	INSERT INTO tblKosten (
		"order", 
		meetplan, 
		meetpunt, 
		meetpakket, 
		prioriteit, 
		jaar, 
		valuta, 
		stukprijs, 
		kostenregel, 
		aantal_jan_bruto,
		aantal_feb_bruto,
		aantal_mrt_bruto,
		aantal_apr_bruto,
		aantal_mei_bruto,
		aantal_jun_bruto,
		aantal_jul_bruto,
		aantal_aug_bruto,
		aantal_sep_bruto,
		aantal_okt_bruto,
		aantal_nov_bruto,
		aantal_dec_bruto,
		aantal_jaar_bruto,
		jan_bruto, 
		feb_bruto, 
		mrt_bruto, 
		apr_bruto, 
		mei_bruto, 
		jun_bruto, 
		jul_bruto, 
		aug_bruto, 
		sep_bruto, 
		okt_bruto, 
		nov_bruto, 
		dec_bruto,
		jaar_bruto,
		aantal_jan_ontdubbeling,
		aantal_feb_ontdubbeling,
		aantal_mrt_ontdubbeling,
		aantal_apr_ontdubbeling,
		aantal_mei_ontdubbeling,
		aantal_jun_ontdubbeling,
		aantal_jul_ontdubbeling,
		aantal_aug_ontdubbeling,
		aantal_sep_ontdubbeling,
		aantal_okt_ontdubbeling,
		aantal_nov_ontdubbeling,
		aantal_dec_ontdubbeling,
		aantal_jaar_ontdubbeling,
		jan_ontdubbeling, 
		feb_ontdubbeling, 
		mrt_ontdubbeling, 
		apr_ontdubbeling, 
		mei_ontdubbeling, 
		jun_ontdubbeling, 
		jul_ontdubbeling, 
		aug_ontdubbeling, 
		sep_ontdubbeling, 
		okt_ontdubbeling, 
		nov_ontdubbeling, 
		dec_ontdubbeling,
		jaar_ontdubbeling,
		aantal_jan_netto,
		aantal_feb_netto,
		aantal_mrt_netto,
		aantal_apr_netto,
		aantal_mei_netto,
		aantal_jun_netto,
		aantal_jul_netto,
		aantal_aug_netto,
		aantal_sep_netto,
		aantal_okt_netto,
		aantal_nov_netto,
		aantal_dec_netto,
		aantal_jaar_netto,
		jan_netto, 
		feb_netto, 
		mrt_netto, 
		apr_netto, 
		mei_netto, 
		jun_netto, 
		jul_netto, 
		aug_netto, 
		sep_netto, 
		okt_netto, 
		nov_netto, 
		dec_netto, 
		jaar_netto,
		redenen_ontdubbeling
	)
	WITH Kosten_CTE AS (
	SELECT 
		K.order AS "order",
		K.meetplan,
		K.meetpunt,
		K.meetpakket,
		K.prioriteit,
		K.jaar,
		K.valuta,
		K.stukprijs,
		K.id AS kostenregel,
		K.aantal_jan AS aantal_jan_bruto,
		K.aantal_feb AS aantal_feb_bruto,
		K.aantal_mrt AS aantal_mrt_bruto,
		K.aantal_apr AS aantal_apr_bruto,
		K.aantal_mei AS aantal_mei_bruto,
		K.aantal_jun AS aantal_jun_bruto,
		K.aantal_jul AS aantal_jul_bruto,
		K.aantal_aug AS aantal_aug_bruto,
		K.aantal_sep AS aantal_sep_bruto,
		K.aantal_okt AS aantal_okt_bruto,
		K.aantal_nov AS aantal_nov_bruto,
		K.aantal_dec AS aantal_dec_bruto,
		K.jan AS jan_bruto, 
		K.feb AS feb_bruto,
		K.mrt AS mrt_bruto,
		K.apr AS apr_bruto,
		K.mei AS mei_bruto,
		K.jun AS jun_bruto,
		K.jul AS jul_bruto,
		K.aug AS aug_bruto,
		K.sep AS sep_bruto,
		K.okt AS okt_bruto,
		K.nov AS nov_bruto,
		K.dec AS dec_bruto,

		-- Ontdubbelingslogica voor elke maand (aantal metingen)
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_jan)) > K.aantal_jan THEN -1 * K.aantal_jan
			ELSE SUM(KO.aantal_jan)
		END, 0) AS aantal_jan_ontdubbeling, 
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_feb)) > K.aantal_feb THEN -1 * K.aantal_feb
			ELSE SUM(KO.aantal_feb)
		END, 0) AS aantal_feb_ontdubbeling, 
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_mrt)) > K.aantal_mrt THEN -1 * K.aantal_mrt
			ELSE SUM(KO.aantal_mrt)
		END, 0) AS aantal_mrt_ontdubbeling, 
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_apr)) > K.aantal_apr THEN -1 * K.aantal_apr
			ELSE SUM(KO.aantal_apr)
		END, 0) AS aantal_apr_ontdubbeling,
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_mei)) > K.aantal_mei THEN -1 * K.aantal_mei
			ELSE SUM(KO.aantal_mei)
		END, 0) AS aantal_mei_ontdubbeling, 
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_jun)) > K.aantal_jun THEN -1 * K.aantal_jun
			ELSE SUM(KO.aantal_jun)
		END, 0) AS aantal_jun_ontdubbeling, 
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_jul)) > K.aantal_jul THEN -1 * K.aantal_jul
			ELSE SUM(KO.aantal_jul)
		END, 0) AS aantal_jul_ontdubbeling, 
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_aug)) > K.aantal_aug THEN -1 * K.aantal_aug
			ELSE SUM(KO.aantal_aug)
		END, 0) AS aantal_aug_ontdubbeling, 
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_sep)) > K.aantal_sep THEN -1 * K.aantal_sep
			ELSE SUM(KO.aantal_sep)
		END, 0) AS aantal_sep_ontdubbeling, 
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_okt)) > K.aantal_okt THEN -1 * K.aantal_okt
			ELSE SUM(KO.aantal_okt)
		END, 0) AS aantal_okt_ontdubbeling, 
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_nov)) > K.aantal_nov THEN -1 * K.aantal_nov
			ELSE SUM(KO.aantal_nov)
		END, 0) AS aantal_nov_ontdubbeling, 
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aantal_dec)) > K.aantal_dec THEN -1 * K.aantal_dec
			ELSE SUM(KO.aantal_dec)
		END, 0) AS aantal_dec_ontdubbeling, 


		-- Ontdubbelingslogica voor elke maand (kosten)
		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.jan)) > K.jan THEN -1 * K.jan
			ELSE SUM(KO.jan)
		END, 0) AS jan_od, 

		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.feb)) > K.feb THEN -1 * K.feb
			ELSE SUM(KO.feb)
		END, 0) AS feb_od,

		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.mrt)) > K.mrt THEN -1 * K.mrt
			ELSE SUM(KO.mrt)
		END, 0) AS mrt_od,

		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.apr)) > K.apr THEN -1 * K.apr
			ELSE SUM(KO.apr)
		END, 0) AS apr_od,

		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.mei)) > K.mei THEN -1 * K.mei
			ELSE SUM(KO.mei)
		END, 0) AS mei_od,

		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.jun)) > K.jun THEN -1 * K.jun
			ELSE SUM(KO.jun)
		END, 0) AS jun_od,

		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.jul)) > K.jul THEN -1 * K.jul
			ELSE SUM(KO.jul)
		END, 0) AS jul_od,

		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.aug)) > K.aug THEN -1 * K.aug
			ELSE SUM(KO.aug)
		END, 0) AS aug_od,

		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.sep)) > K.sep THEN -1 * K.sep
			ELSE SUM(KO.sep)
		END, 0) AS sep_od,

		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.okt)) > K.okt THEN -1 * K.okt
			ELSE SUM(KO.okt)
		END, 0) AS okt_od,

		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.nov)) > K.nov THEN -1 * K.nov
			ELSE SUM(KO.nov)
		END, 0) AS nov_od,

		COALESCE(
		CASE 
			WHEN (-1 * SUM(KO.dec)) > K.dec THEN -1 * K.dec
			ELSE SUM(KO.dec)
		END, 0) AS dec_od,

		-- Aggregation of reasons
		STRING_AGG(reden_ontdubbeling, ' ') AS redenen_ontdubbeling
	FROM 
		tblKostenregels AS K 
	LEFT JOIN 
		tblOntdubbelregels AS KO 
		ON K.id = KO.kostenregel
	GROUP BY 
		K.id
	)

	SELECT 
	"order",
	meetplan,
	meetpunt,
	meetpakket,
	prioriteit,
	jaar,
	valuta,
	stukprijs,
	kostenregel,

	-- Bruto aantallen
	aantal_jan_bruto,
	aantal_feb_bruto,
	aantal_mrt_bruto,
	aantal_apr_bruto,
	aantal_mei_bruto,
	aantal_jun_bruto,
	aantal_jul_bruto,
	aantal_aug_bruto,
	aantal_sep_bruto,
	aantal_okt_bruto,
	aantal_nov_bruto,
	aantal_dec_bruto,
	
	aantal_jan_bruto +
	aantal_feb_bruto +
	aantal_mrt_bruto +
	aantal_apr_bruto +
	aantal_mei_bruto +
	aantal_jun_bruto +
	aantal_jul_bruto +
	aantal_aug_bruto +
	aantal_sep_bruto +
	aantal_okt_bruto +
	aantal_nov_bruto +
	aantal_dec_bruto AS aantal_jaar_bruto,
		
	-- Bruto values
	jan_bruto,
	feb_bruto,
	mrt_bruto,
	apr_bruto,
	mei_bruto,
	jun_bruto,
	jul_bruto,
	aug_bruto,
	sep_bruto,
	okt_bruto,
	nov_bruto,
	dec_bruto,

	jan_bruto +
	feb_bruto +
	mrt_bruto +
	apr_bruto +
	mei_bruto +
	jun_bruto +
	jul_bruto +
	aug_bruto +
	sep_bruto +
	okt_bruto +
	nov_bruto +
	dec_bruto AS jaar_bruto,

	-- Ontdubbelingswaarden aantal
	aantal_jan_ontdubbeling AS aantal_jan_ontdubbeling,
	aantal_feb_ontdubbeling AS aantal_feb_ontdubbeling,
	aantal_mrt_ontdubbeling AS aantal_mrt_ontdubbeling,
	aantal_apr_ontdubbeling AS aantal_apr_ontdubbeling,
	aantal_mei_ontdubbeling AS aantal_mei_ontdubbeling,
	aantal_jun_ontdubbeling AS aantal_jun_ontdubbeling,
	aantal_jul_ontdubbeling AS aantal_jul_ontdubbeling,
	aantal_aug_ontdubbeling AS aantal_aug_ontdubbeling,
	aantal_sep_ontdubbeling AS aantal_sep_ontdubbeling,
	aantal_okt_ontdubbeling AS aantal_okt_ontdubbeling,
	aantal_nov_ontdubbeling AS aantal_nov_ontdubbeling,
	aantal_dec_ontdubbeling AS aantal_dec_ontdubbeling,

	aantal_jan_ontdubbeling + 
	aantal_feb_ontdubbeling +
	aantal_mrt_ontdubbeling +
	aantal_apr_ontdubbeling +
	aantal_mei_ontdubbeling +
	aantal_jun_ontdubbeling +
	aantal_jul_ontdubbeling +
	aantal_aug_ontdubbeling +
	aantal_sep_ontdubbeling +
	aantal_okt_ontdubbeling +
	aantal_nov_ontdubbeling +
	aantal_dec_ontdubbeling	AS aantal_jaar_ontdubbeling,
		
	-- Ontdubbelingswaarden kosten (replacing NULL with 0)
	jan_od AS jan_ontdubbeling,
	feb_od AS feb_ontdubbeling,
	mrt_od AS mrt_ontdubbeling,
	apr_od AS apr_ontdubbeling,
	mei_od AS mei_ontdubbeling,
	jun_od AS jun_ontdubbeling,
	jul_od AS jul_ontdubbeling,
	aug_od AS aug_ontdubbeling,
	sep_od AS sep_ontdubbeling,
	okt_od AS okt_ontdubbeling,
	nov_od AS nov_ontdubbeling,
	dec_od AS dec_ontdubbeling,

	jan_od +
	feb_od +
	mrt_od +
	apr_od +
	mei_od +
	jun_od +
	jul_od +
	aug_od +
	sep_od +
	okt_od +
	nov_od +
	dec_od AS jaar_ontdubbeling,

	-- Netto waarden voor aantal metingen in maand (bruto + ontdubbeling)
	aantal_jan_bruto + aantal_jan_ontdubbeling AS aantal_jan_netto,
	aantal_feb_bruto + aantal_feb_ontdubbeling AS aantal_feb_netto,
	aantal_mrt_bruto + aantal_mrt_ontdubbeling AS aantal_mrt_netto,
	aantal_apr_bruto + aantal_apr_ontdubbeling AS aantal_apr_netto,
	aantal_mei_bruto + aantal_mei_ontdubbeling AS aantal_mei_netto,
	aantal_jun_bruto + aantal_jun_ontdubbeling AS aantal_jun_netto,
	aantal_jul_bruto + aantal_jul_ontdubbeling AS aantal_jul_netto,
	aantal_aug_bruto + aantal_aug_ontdubbeling AS aantal_aug_netto,
	aantal_sep_bruto + aantal_sep_ontdubbeling AS aantal_sep_netto,
	aantal_okt_bruto + aantal_okt_ontdubbeling AS aantal_okt_netto,
	aantal_nov_bruto + aantal_nov_ontdubbeling AS aantal_nov_netto,
	aantal_dec_bruto + aantal_dec_ontdubbeling AS aantal_dec_netto,

	aantal_jan_bruto + aantal_jan_ontdubbeling +
	aantal_feb_bruto + aantal_feb_ontdubbeling +
	aantal_mrt_bruto + aantal_mrt_ontdubbeling +
	aantal_apr_bruto + aantal_apr_ontdubbeling +
	aantal_mei_bruto + aantal_mei_ontdubbeling +
	aantal_jun_bruto + aantal_jun_ontdubbeling +
	aantal_jul_bruto + aantal_jul_ontdubbeling +
	aantal_aug_bruto + aantal_aug_ontdubbeling +
	aantal_sep_bruto + aantal_sep_ontdubbeling +
	aantal_okt_bruto + aantal_okt_ontdubbeling +
	aantal_nov_bruto + aantal_nov_ontdubbeling +
	aantal_dec_bruto + aantal_dec_ontdubbeling AS aantal_jaar_netto,
		
	-- Netto waarden voor kosten in maand (bruto + ontdubbeling)
	jan_bruto + jan_od AS jan_netto,
	feb_bruto + feb_od AS feb_netto,
	mrt_bruto + mrt_od AS mrt_netto,
	apr_bruto + apr_od AS apr_netto,
	mei_bruto + mei_od AS mei_netto,
	jun_bruto + jun_od AS jun_netto,
	jul_bruto + jul_od AS jul_netto,
	aug_bruto + aug_od AS aug_netto,
	sep_bruto + sep_od AS sep_netto,
	okt_bruto + okt_od AS okt_netto,
	nov_bruto + nov_od AS nov_netto,
	dec_bruto + dec_od AS dec_netto,

	jan_bruto + jan_od +
	feb_bruto + feb_od +
	mrt_bruto + mrt_od +
	apr_bruto + apr_od +
	mei_bruto + mei_od +
	jun_bruto + jun_od +
	jul_bruto + jul_od +
	aug_bruto + aug_od +
	sep_bruto + sep_od +
	okt_bruto + okt_od +
	nov_bruto + nov_od +
	dec_bruto + dec_od AS jaar_netto,

	redenen_ontdubbeling
	FROM 
	Kosten_CTE;

	RETURN NEW;
END; $$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER order_after_delete
	AFTER DELETE ON tblOrders
	EXECUTE FUNCTION Kosten_Ontdubbelen();

CREATE OR REPLACE TRIGGER kosten_update
	AFTER INSERT OR UPDATE ON tblKostenregels
	FOR EACH ROW EXECUTE FUNCTION Kosten_Ontdubbelen();

