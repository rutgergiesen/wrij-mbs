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


INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('abs254','Absorptiebepaling bij 254nm','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('afvoer','Afvoerkostenfles','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('afwkg','Afwijking','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('agaw','Zilver','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('agbs','Zilver','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('agow','Zilver','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('agz1','Zilver','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('alaw','Aluminium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('albs','Aluminium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('alggp','Bedekking algen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('alow','Aluminium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('alz1','Aluminium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('asaw','Arseen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('asbs','Arseen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('asow','Arseen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('asz1','Arseen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('baaw','Barium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('babs','Barium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bacdrijf','Categorie Cyanobacteriedrijflaag','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('badgt','Badgasten','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('baow','Barium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('baw','Boor','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('baz1','Barium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('beaw','Beryllium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem','Bemonstering','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bemad-boot','additionele kosten bemonstering m.b.v. boot','ILOW',40,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bemad-fyto','additionele kosten fytoplankton bemonstering','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bemad-hybi','Toeslag combinatie hydrobiologische bemonstering','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-aw','Bemonstering Afvalwater (RioolWaterZuiveringsInstallaties)','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-awi','Instellen monsterkast','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-awi-icmb','Instellen monsterkast na monsterneming','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-awil','Locatiebezoek rwzi instellen.','ILOW',40,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-awml','Locatiebezoek bemonsteren','ILOW',40,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-bs','Bemonstering Waterbodem','ILOW',120,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-gw','Bemonstering Grondwater (peilbuizen)','ILOW',25,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-gwl','Starttarief Bemonstering Grondwater (peilbuizen)','ILOW',70,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-hybi','Bemonstering Hydrobiologie','ILOW',40,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-hybiloc','Locatiebezoek hydrobiologie monstername niet mogelijk','ILOW',40,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-meng','Mengen in het veld','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem-ow','Bemonstering Oppervlaktewater','ILOW',40,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bem2p','Bemonstering door 2 personen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('beow','Beryllium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bez1','Bezinksel','ILOW',4,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('biomatonb','Biologisch materiaal onbekend','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('blauwalgbio','Cyanobacterien Biovolume','ILOW',70,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('blauwalgdrijf','Cyanobacterien Drijflaag','ILOW',30,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('blauwalgprescn','Cyanobacterien PreScan','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('blauwalgv','Blauwalg veldmeting algentoorts','ILOW',22,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('boorbeschrijving','Boorbeschrijving Terra index','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bow','Boor','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('brandverzs','Brandvertragers in zwevende stof','ILOW',180,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('btexn','Aromaten (BTEXN)','ILOW',40,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('bzv','Biochemisch zuurstofverbruik (als O2) over 5 dagen','ILOW',12,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('caaw','Calcium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('cabs','Calcium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('caco','Calciumcarbonaat','ILOW',10,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('caco3','Calciumcarbonaat','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('caow','Calcium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('caz1','Calcium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('cdaw','Cadmium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('cdbs','Cadmium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('cdow','Cadmium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('cdz1','Cadmium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('chla','Chlorofyl','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('chlav','Totaal chlorofyl veldmeting algentoorts','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('cl','Chloride','ILOW',6,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('clg','Chloride','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('coaw','Kobalt','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('cobs','Kobalt','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('coow','Kobalt','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('coz1','Kobalt','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('craw','Chroom','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('crbs','Chroom','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('crow','Chroom','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('crz1','Chroom','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('cuaw','Koper','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('cubs','Koper','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('cuow','Koper','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('cuz1','Koper','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('czv','Chemisch zuurstofverbruik (als O2)','ILOW',13,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('czvcuv','Chemisch zuurstofverbruik (als O2) cuvettentest','ILOW',8,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('czvg','Chemisch zuurstofverbruik (als O2)','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('datarapport','Datarapporten uitleveren Hydrobiologie','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('debbeg','Debiet Begin','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('debdag','Debiet per dag','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('debeind','Debiet Eind','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('debiet','Debiet','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('debnetto','Netto Debiet','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('debuur','Debiet per uur','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dest','Ontsluiting metalen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('diato-bem','Diatomeeën bemonstering','ILOW',40,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('diato-bem-kn','Diatomeeën bemonstering (Knijp-methode)','ILOW',40,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('diato-bem-nt','Diatomeeën bemonstering (Net-methode)','ILOW',40,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('diepte','Diepte','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-acutus','DNA Procambarus acutus','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-anatoxine','Anatoxine producerende genen (aantal gen-kopieen)','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-bever','DNA bever','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-beverrat','DNA Beverrat','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-cabomba','DNA Cabomba','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-clarkii','DNA Procambarus clarkii','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-cylindrospermops','Cylindrospermopsine producerende genen (aantal gen-kopieen)','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-drdmictparv','DNA microthrix parvicella (draadvormer)','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-drdprofil','DNA candidatus promineofilum (draadvormer)','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-eikpcrups','DNA Eikenprocessierups','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-gmod','DNA Grote modderkruiper','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-leniusculus','DNA Pacifastacus leniusculus','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-limosus','DNA Orconectus limosus','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-microcystine','Microcystine producerende genen (aantal gen-kopieen)','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-muskrt','DNA muskusrat','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-paprika','DNA Paprika','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-rannvrs','DNA Ranavirus','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-saxotoxine','Saxotoxine producerende genen (aantal gen-kopieen)','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-tomaat','DNA Tomaat','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-trichbhzia','DNA Trichobilharzia','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-vb','Monstervoorbehandeling DNA','ILOW',50,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-vederkruid','DNA Vederkruid','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-virginalis','DNA Procambarus virginalis','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dna-virilis','DNA Orconectes virilis','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dnb','Opgelost organisch en anorganisch gebonden stikstof','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('doc','Opgelost organisch koolstof','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('doorz','Doorzicht (Ø 20 cm/six holes)','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('drijf','Bedekking drijflaag vegetatie','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('droogslo','Droogstand watergang','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('droogval','Droogvallingsgraad','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ds2','Percentage droge stof (t.b.v. lutum)','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dummy','Dummy test: i.v.m. niet te koppelen testen.','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('dvp','Diepvriespotje (bewaarmonster)','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ec50','Nitrificatieremming (op basis van NO2+NO3)','ILOW',494,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('egvv','Elektrisch geleidingsvermogen (EGV)','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('egv25','Elektrisch geleidingsvermogen (EGV)','ILOW',3,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ext450','Extinctiebepaling bij 450nm','ILOW',20,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('feaw','IJzer','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('febs','IJzer','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('feow','IJzer','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('fez1','IJzer','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('fe2o3','IJzer(III)oxide (vrij ijzer, als Fe2O3)','ILOW',10,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('fluorprb-blauw','Fluoroprobe bepaling algengroepen','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('fluorprb-tot','Fluoroprobe bepaling algengroepen','ILOW',17,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('fostac','FOS/TAC ratio','ILOW',8,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('fytop','Fytoplankton','ILOW',155,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('fytop-qsven','Fytoplankton Quick Scan in vennen','ILOW',25,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gcms-bma','Bestrijdingsmiddelen (GCMS)','ILOW',160,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gcms-bma-h','Bestrijdingsmiddelen (GCMS)','ILOW',100,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gcms-bsa','Bijzondere stoffen (GCMS)','ILOW',120,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gcms-bsb','Bijzondere stoffen (GCMS)','ILOW',160,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gcms-fenfta','Alkylfenolen en ftalaten','ILOW',120,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gcms-mpv','Matig Polaire Verbindingen (GCMS)','ILOW',130,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gcms-nts','Bestrijdingsmiddelen NTS (GCMS)','ILOW',300,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gcms-screen','Screening (GCMS)','ILOW',200,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gcms-screenopw','Opwerking Screening (GCMS)','ILOW',80,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gdaw','Gadolinium','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gdow','Gadolinium','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('geur','Geur','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('glds2','Gloeirest van de droge stof (t.b.v. zeefkromme)','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('glind','Percentage gloeirest','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gloeiv','Gloeiverlies (Organische stof zonder correctie voor lutum en vrij ijzer)','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('glonopa','Percentage gloeirest','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('glonopo','Percentage gloeirest','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('glonops','Percentage gloeirest','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('gonsmsem','Fytopl. - bloeisoort (13) Gonyostomum semen','ILOW',30,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('groei','Overmatige groei hogere waterplanten','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('hardhcaco3','Hardheid (als CaCO3)','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('hardheid','Hardheid','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('hco3','Waterstofcarbonaat','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('helder','Helderheid','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('helderv','Helderheid','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('hgaw','Kwik','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('hgbs','Kwik','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('hgow','Kwik','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('hgz1','Kwik','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('hs-bsa','Vluchtige polaire verbindingen','ILOW',65,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ijstsd','IJstoestand / aggregatietoestand van het water','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ind','Droge stof','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ionenratio','Ionenratio','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('kaw','Kalium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('kbs','Kalium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('kgf16','Korrelgroottefractie tot 16 um','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('kgf2','Korrelgroottefractie tot 2 um','ILOW',35,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('kgf32','Korrelgroottefractie tot 32 um','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('kleur','Kleur','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('kleurv','Kleur','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('kow','Kalium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('kroos','Kroos','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('kz1','Kalium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-bmc','Bestrijdingsmiddelen (LCMS)','ILOW',120,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-bmc-h','Bestrijdingsmiddelen (LCMS)','ILOW',75,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-bmd','Bestrijdingsmiddelen (LCMS)','ILOW',160,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-bmd-h','Bestrijdingsmiddelen (LCMS)','ILOW',100,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-bme','Bestrijdingsmiddelen (LCMS)','ILOW',120,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-bme-h','Bestrijdingsmiddelen (LCMS)','ILOW',75,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-bsa','Bijzondere stoffen (LCMS)','ILOW',80,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-bsc','Bijzondere stoffen (LCMS)','ILOW',80,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-bsd','Bijzondere stoffen (LCMS)','ILOW',80,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-gidsstof','Gidsstoffen (LCMS)','ILOW',100,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-gma','Geneesmiddelen (LCMS)','ILOW',120,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-gmb','Geneesmiddelen (LCMS)','ILOW',120,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-gmc','Geneesmiddelen (LCMS)','ILOW',80,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-nts','Bestrijdingsmiddelen NTS (LCMS)','ILOW',300,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-pfasg1','PFAS AS3000 (LCMS)','ILOW',130,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lcms-pfasg2','PFAS overig (LCMS)','ILOW',130,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('liaw','Lithium','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lichtcondities','Lichtcondities doorzicht','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('liow','Lithium','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('locatie','Locatie veldwerkzaamheden','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('macfn-bemuitvf','Macrofauna bemonsteren, uitzoeken en veldformulier','ILOW',305,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('macfn-det','Macrofauna determineren','ILOW',485,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('macfn-qs','Macrofauna quick scan','ILOW',140,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('macfn-qssted','Macrofauna quick scan','ILOW',150,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('macfn-std','Macrofauna standaard','ILOW',790,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('macfn-std-extra','Macrofauna standaard (extra individuen)','ILOW',905,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('macfn-sub','Macrofauna met subbemonstering','ILOW',1015,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('metbeh','Behandeling Metalen Onderzoek','ILOW',45,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mgaw','Magnesium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mgbs','Magnesium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mgow','Magnesium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mgz1','Magnesium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mnaw','Mangaan','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mnbs','Mangaan','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mnow','Mangaan','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mnz1','Mangaan','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('moaw','Molybdeen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mobs','Molybdeen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('monbeh','Behandeling Monster','ILOW',8,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('monb25','Monsterbehandeling – 25 ilowpunten','ILOW',25,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('monb35','Monsterbehandeling – 35 ilowpunten','ILOW',25,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('monb50','Monsterbehandeling – 50 ilowpunten','ILOW',25,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('moow','Molybdeen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('moz1','Molybdeen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mpn_ecoli','Escherichia coli (MPN-methode)','ILOW',36,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mpn_ientro','Intestinale enterococcen (MPN-methode)','ILOW',36,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('mpn_inzet','Inzetten MPN methode','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('naaw','Natrium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('nabs','Natrium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('naow','Natrium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('naz1','Natrium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('neer','Neerslag','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('nh3','Ammoniak','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('nh4','Ammonium (als N)','ILOW',6,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('nh4g','Ammonium (als N)','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('niaw','Nikkel','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('nibs','Nikkel','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('niow','Nikkel','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('niz1','Nikkel','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('nka','Som ammonium- en organisch gebonden stikstof (als N)','ILOW',11,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('nkj','Som ammonium- en organisch gebonden stikstof, Kjeldahl (als N)','ILOW',13,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('nkjg','Stikstof Kjeldahl (als N)','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('not','Som nitraat en nitriet (als N)','ILOW',6,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('no2','Nitriet (als N)','ILOW',6,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('no3','Nitraat (als N)','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('no3g','Nitraat (als N)','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('n_remming','Nitrificatieremming (beperkte proef, op basis van NO2+NO3)','ILOW',119,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('n-snelheid','Nitrificatiesnelheid (als N)','ILOW',86,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ntot','Stikstof totaal','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ocb','Organochloorbestrijdingsmiddelen','ILOW',90,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ocbg','Organochloorbestrijdingsmiddelen','ILOW',90,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ofos','Orthofosfaat (als P)','ILOW',6,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ofosg','Orthofosfaat (als P)','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('olie','Olie','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('oliegc','Minerale olie','ILOW',80,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('oliegcg','Minerale olie','ILOW',80,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('oliegcid','Olie identificatie','ILOW',80,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('oliegrav','Petroleumether extraheerbare oliën en vetten','ILOW',30,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('oliegravg','Petroleumether extraheerbare oliën en vetten','ILOW',30,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('onopa','Onopgeloste stoffen','ILOW',8,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('onopo','Onopgeloste stoffen','ILOW',8,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('onops','Onopgeloste stoffen','ILOW',8,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ostof','Organische stof','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('o2v','Zuurstof','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('o2z','Zuurstof','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pak','Polycyclische aromaten','ILOW',90,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pakg','Polycyclische aromaten','ILOW',90,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pbafwkok76','Afwerking Peilbuis d.m.v. koker doorsnede 76mm','ILOW',27,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pbafwstrk','Afwerking Peilbuis d.m.v. straatkolk','ILOW',11,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pbaw','Lood','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pbbs','Lood','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pbgws','Grondwaterstand Peilbuis t.o.v. bovenkant peilbuis','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pbow','Lood','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pbpl','Plaatsen Peilbuis','ILOW',110,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pbpll','Starttarief Plaatsen Peilbuis','ILOW',180,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pbveld','Veldformulier t.b.v. Peilbuizen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pbz1','Lood','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pcb','Polychloorbifenylen','ILOW',90,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pcbg','Polychloorbifenylen','ILOW',90,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('peilschaalv','Aflezen NAP stand op peilschaal','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ph','Zuurgraad','ILOW',3,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('phh2o','Zuurgraad (pH-H2O)','ILOW',10,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('phv','Zuurgraad','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('planaw','Plannen Afvalwater','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('plandiato','Plannen Diatomeeën','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('plangw','Plannen Grondwater','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('planmacfn','Plannen Macrofauna','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('planow','Plannen Oppervlaktewater','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('plansieragn','Plannen Sieralgen','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('planvegtte','Plannen Vegetatie','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('planz1','Plannen Zuiveringsslib','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('projcoodnte-hybi','Projectcoordinatie Hydrobiologie','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('projh','Projecthandeling','ILOW',25,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pulsen','Aantal pulsen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pulsgen','Aantal pulsen genomen','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('pulsgev','Aantal pulsen gevraagd','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('riscnvcanbtr','Risiconiveau cyanobacteriën','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('saliniteit','Saliniteit','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sbaw','Antimoon','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sbbs','Antimoon','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sbow','Antimoon','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sbz1','Antimoon','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('schuim','Schuim','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('seaw','Selenium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sebs','Selenium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('senskb','Sensor kalibratie','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sensoh','Sensor onderhoud','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('seow','Selenium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sez1','Selenium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sieragn','Sieralgen','ILOW',335,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('snaw','Tin','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('snbs','Tin','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('snow','Tin','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('snz1','Tin','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('so4','Sulfaat','ILOW',9,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('so4g','Sulfaat','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sraw','Strontium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('srow','Strontium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('stroomshd','Stroomsnelheid','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sttlaw','Zwavel','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sttlbs','Zwavel','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sttlow','Zwavel','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sttlz1','Zwavel','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('teaw','Telluur','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tebs','Telluur','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('temp','Temperatuur','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tempkast','Temperatuur kast','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('teow','Telluur','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tez1','Telluur','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tiaw','Titaan','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tic','Anorganisch koolstof (TIC)','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tiow','Titaan','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tiz1','Titaan','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tlaw','Thallium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tlbs','Thallium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tlow','Thallium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tlz1','Thallium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tnb','Totaal organisch en anorganisch gebonden stikstof','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('toc','Totaal organisch koolstof','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('toesgbereenh','Toeslag berekening extra eenheid','ILOW',25,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('toesgbooth','Toeslag monsterneming met boot (inclusief extra persoon)','ILOW',90,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('toesmedwrk','Toeslag monsterneming met extra medewerker ivm veiligheidsaspecten','ILOW',50,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tofos','Orthofosfaat (ongefiltreerd)','ILOW',6,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('totalk','Alkaliniteit','ILOW',8,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('toxblauwalg','Chlorofyl-a geassocieerd met blauwalgen (toetswaarde)','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tpa','Totaal fosfor (als P)','ILOW',11,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('tpag','Totaal fosfor (als P)','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('troealgt','Troebelheid m.b.v. algentoorts','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('troev','Troebelheid','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('uaw','Uranium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('uow','Uranium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('upldndff','Upload biologische gegevens naar NDFF','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('uploadzw','Upload Zwemwaterregister','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vaw','Vanadium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vbs','Vanadium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vcent','Voorbewerking Centrifugeren','ILOW',5,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ve','Vervuilingswaarde','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vegtte','Vegetatie overig','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vegtte-krw','Vegetatie KRW oever en water','ILOW',125,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vegtte-qs','Vegetatie quick scan','ILOW',140,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vegtte-vrst','Vegetatie vooropname vroege soorten','ILOW',75,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('veldbeh','Behandeling Veldwaarnemingen','ILOW',2,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('veldmtgn','Veldmetingen','ILOW',8,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vetid','Vet identificatie','ILOW',80,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vfilt','Filtratie uitgevoerd','ILOW',10,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vlverb','Vluchtige verbindingen','ILOW',80,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vmeng','Mengmonster','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vogl','Vogels','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('volkolf','Volume kolf','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('volvatleeg','Volume vat leeg','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('volvatpr','Volume vat praktisch','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('volvatth','Volume vat theoretisch','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('volvatvol','Volume vat vol','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vow','Vanadium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vpfgh001','Verpakking FGH001','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vpfgh004','Verpakking FGH004','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vpfgh007','Verpakking FGH007','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vpfgh010','Verpakking FGH010','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vpfgh014','Verpakking FGH014','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vpfgh015','Verpakking FGH015','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vpfgh024','Verpakking FGH024','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vpfgh047','Verpakking FGH047','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vporvion100','Verpakking Orvion - 100 ml - bevat conserveringsmiddel (20 ml alcohol)','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vrivm','Verpakking RIVM','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vuil','Vuil','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vzegel','Verzegeling Monsternamekast','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('vz1','Vanadium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('watherkomst','Waterherkomst oppervlaktewater','ILOW',1,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('waw','Wolfraam','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('w_bez volume_veld','Bezinkselvolume na 1/2 uur','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('wbs','Wolfraam','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('wbtoets','Toetsing aan Regeling bodemkwaliteit 2022','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('wbtoetsgbt','Baggerspecie bij GBT in oppervlaktewater (emissiewaarde)','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('wbtoetsgbtlb','Baggerspecie bij GBT op landbodem (emissiewaarde)','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('wbtoetskls','Grond en bagger bij toepassing op of in bodem','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('wbtoetsopp','Bagger en ontvangende bodem bij toepassing in opp.waterl.','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('wbtoetspfas','Toetsing PFAS aan Handelingskader (december 2021)','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('wbveld','Waterbodem veldformulier','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('wbvoor','Waterbodem vooronderzoek','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('w_deelvolume_veld','Aantal ml per deelmonster','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('weercondities','Weercondities doorzicht','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('wow','Wolfraam','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('w_tmax_veld','Maximum temperatuur gekoelde kast','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('w_tmin_veld','Minimum temperatuur gekoelde kast','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('w_tot volume_veld','Totaal monstervolume','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('w_verdunn_veld','Verdunning ingezet voor bezinkselvolume t.b.v. SVI','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('wz1','Wolfraam','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zain','Percentage zandrest','ILOW',15,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zeefkr','Zeefkromme','ILOW',45,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zeefzain','Zeeffractie van de Zandrest','ILOW',60,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('znaw','Zink','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('znbs','Zink','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('znow','Zink','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('znz1','Zink','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zraw','Zirkonium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zrow','Zirkonium','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zwemmjk','Zwemmersjeuk','ILOW',0,'Individueel');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lano01','Anorganisch   (pakket 01)','ILOW',13,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lbac02','Bacteriologisch onderzoek','ILOW',72,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lbest02','Organisch (gezamelijke bestrijdingsmiddelenrapportage)','ILOW',560,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lbest02-h','lbest02-h','ILOW',350,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lglyampa','WRIJ oppervlaktewater glyfosaat-ampa','ILOW',NULL,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lheffing1','Heffing pakket','ILOW',64,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('licpaw','ICP-MS pakket Afvalwater','ILOW',45,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('licpbs','ICP-MS pakket Waterbodem','ILOW',55,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('licpow','ICP-MS pakket Oppervlaktewater, RWZI Influent en Effluent.','ILOW',45,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('licpz1','ICP-MS pakket Slib','ILOW',55,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lkast01','Bemonstering kast','ILOW',0,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lkrwkwart','Kaderrichtlijnen - kwartaalmonster','ILOW',2125,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lkrwmaand','Kaderrichtlijnen - maandmonster','ILOW',1765,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lopp01','Oppervlaktewater   (pakket 01)','ILOW',62,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lopp02','Oppervlaktewater   (pakket 02)','ILOW',65,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lpbblanco','Blanco peilbuizen','ILOW',554,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lslib05','Slib   (pakket 05)','ILOW',26,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lslib06','Slib (pakket 06)','ILOW',110,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ltech01','Technologie   (pakket 01)','ILOW',50,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ltech02','Technologie   (pakket 02)','ILOW',56,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lveldpb','Veldpakket Peilbuizen','ILOW',11,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lveld01','Veldpakket Oppervlaktewater','ILOW',14,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lveld09','Uitgebreid pakket veldmetingen','ILOW',14,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lvzw01','Veldpakket Zwemwater','ILOW',14,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lwbc1','Waterbodempakket C1, Regeling bodemkwaliteit 2022','ILOW',596,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lwbregwat','Waterbodem pakket Regionale Wateren','ILOW',506,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sap_bijzstffn','sap_bijzstffn','ILOW',240,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sap_geneesm','sap_geneesm','ILOW',240,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sap_lcmsbmde','sap_lcmsbmde','ILOW',280,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sapnf_cadmiumhh','sapnf_cadmiumhh','ILOW',45,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sapnf_macroion','sapnf_macroion','ILOW',45,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sap_nh4nh3','sap_nh4nh3','ILOW',13,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sap_niettoetsb','sap_niettoetsb','ILOW',600,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sap_ptotntot','sap_ptotntot','ILOW',50,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sap_vldbasis','sap_vldbasis','ILOW',12,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sap_vldbio','sap_vldbio','ILOW',14,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('sap_waterkrktr','sap_waterkrktr','ILOW',28,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yat','WRIJ at','ILOW',13,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yat-veld','WRIJ at veldmetingen','ILOW',4,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ycos','WRIJ cos','ILOW',35,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ycp1','WRIJ compost cluster 1','ILOW',20,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ycp1dun','WRIJ compost cluster1 vloeibaar slib','ILOW',13,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ycp2','WRIJ compost cluster 2','ILOW',55,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ycp3','WRIJ compost cluster 3','ILOW',60,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ydoc_hh','WRIJ doc_hardheid','ILOW',17,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yef-veld','WRIJ effluent veldmetingen','ILOW',2,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yef0','WRIJ effluent gezamenlijk','ILOW',75,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yinf','WRIJ influent, deelstromen, voorbezink','ILOW',50,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yinfl-mbs','WRIJ influent mbs','ILOW',59,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yinfl-plus','WRIJ obg infl aviko, obg centraat, ltv infl iwl','ILOW',63,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yinfl-zpn-vw2','WRIJ influent zpn vw2','ILOW',69,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yinf-veld','WRIJ influent veldmetingen','ILOW',2,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yint-stromen','WRIJ internestromen','ILOW',36,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ynutr','WRIJ oppervlaktewater nutrienten','ILOW',42,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yow','WRIJ oppw','ILOW',71,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('ysg','WRIJ slibgisting','ILOW',10,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yveld-algea','WRIJ veldpakket Algeatorch metingen','ILOW',24,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yveld-chemie','WRIJ oppervlaktewater veld-chemie','ILOW',12,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yveld-gw','WRIJ grondwater veld','ILOW',8,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yveld-zw','WRIJ zwemwater veldmetingen','ILOW',12,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yzm8-ef','WRIJ 8x metalen effl.','ILOW',45,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yzm8-in','WRIJ influent 8x metalen','ILOW',45,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('yzs','WRIJ zuiveringsslib','ILOW',95,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zov1','ZZL opp.water veld 1','ILOW',12,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zo30','ZZL opp.water 30 (onop)','ILOW',13,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zrv1','ZZL techn. veld 1','ILOW',4,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zr02','ZZL technologie 2','ILOW',47,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zr03','ZZL technologie 3','ILOW',80,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zr04','ZZL technologie 4','ILOW',75,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zr05','ZZL technologie 5','ILOW',38,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zr06','ZZL technologie 6','ILOW',56,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zr07','ZZL technologie  7','ILOW',301,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zr08','ZZL technologie 8','ILOW',296,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zs02','ZZL techn. slib 2','ILOW',75,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('zs05','ZZL techn. slib 5','ILOW',50,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('licpow_nf','ICP-MS pakket Oppervlaktewater, RWZI Influent en Effluent. Na filtratie','ILOW',45,'Pakket');
INSERT INTO tblMeetpakketten(Naam,Omschrijving,Valuta,Stukprijs,Type) VALUES ('lglyampa','glyfosaat en AMPA meting','ILOW',300,'Pakket');
