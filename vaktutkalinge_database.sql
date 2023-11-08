-- Oppretter en ny database ved navn "vaktutkallingar"
create database vaktutkallingar;

-- Velger "vaktutkallingar" databasen for videre operasjoner
use vaktutkallingar;

-- Oppretter en ny tabell ved navn "dataset" med spesifiserte kolonner og datatyper
CREATE TABLE dataset (
    AOnr INT PRIMARY KEY,          -- Primær nøkkel for tabellen
    Objektnr VARCHAR(255),         -- Objektnummer
    Objektnavn VARCHAR(255),       -- Navn på objektet
    Jobbomr VARCHAR(255),          -- Jobbområde
    Jobbtype VARCHAR(255),         -- Type jobb (vedlikehold, korrigering, osv.)
    Status VARCHAR(255),           -- Status for jobben (ferdigmeldt, pågående, osv.)
    AO_tekst TEXT,                 -- Beskrivende tekst
    K VARCHAR(255),                -- Usikker på hva denne representerer 
    Pr CHAR(1),                    -- Usikker på hva denne representerer 
    Pl_ferdig DATE,                -- Planlagt ferdigstillelsesdato
    Utførande VARCHAR(255),        -- Den som utfører jobben
    Est FLOAT,                     -- Estimert verdi (kanskje tid eller kostnad)
    Fakt FLOAT,                    -- Faktisk verdi (kanskje tid eller kostnad)
    Fag VARCHAR(255),              -- Fagområde (elektrisk, mekanisk, osv.)
    Ferdig DATE                    -- Faktisk ferdigstillelsesdato
);

-- Sletter "dataset" tabellen
DROP TABLE dataset;

-- Setter inn en rad med data i "dataset" tabellen
INSERT INTO dataset
(AOnr, Objektnr, Objektnavn, Jobbomr, Jobbtype, Status, AO_tekst, K, Pr, Pl_ferdig, Utførande, Est, Fakt, Fag, Ferdig)
VALUES (730823, 'KJ-442', 'Truck Diesel Toyota 40-8FD60', 'Vedlikehald', 'Korrigerande', 'Ferdigmeldt', 'Høy temperatur ---> fyllt kjølebveske', NULL, 'U', '2021-09-01', 'vakt_kj', 2.0, 1.0, NULL, '2021-09-01');

-- Setter inn en annen rad med data i "dataset" tabellen
INSERT INTO dataset
(AOnr, Objektnr, Objektnavn, Jobbomr, Jobbtype, Status, AO_tekst, K, Pr, Pl_ferdig, Utførande, Est, Fakt, Fag, Ferdig)
VALUES (730824, 'EP-217-007','Fyllesjakt for kaldt bad (RR-anl)','Vedlikehald','Korrigerande', 'Ferdigmeldt','Klump i sjakt tygger ikke unna ---> Sjå 5xWhy',3.0,'U','2021-09-01','vakt_mekanisk',2.0,2.0,'Mekanisk','2021-09-02');

-- Henter alle rader fra "dataset" tabellen
SELECT * from dataset;

# Slette alle dataene i tabellen
TRUNCATE TABLE dataset;

# Kommando for å finne ut hvor MySQL server har tilgang til 
SHOW VARIABLES LIKE 'secure_file_priv';

DESCRIBE dataset;

# Legge til data fra csv fil
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.1\\Uploads\\Datasett_vaktutkallingar.csv'
INTO TABLE dataset
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- Henter alle rader fra "dataset" tabellen
# kommentar 
-- kommentar 
SELECT * from dataset limit 2;

SELECT *
	from dataset
    where Fakt > 10
	;

# Noen spørringer 
-- Tell det totale antallet oppføringer i datasett-tabellen.
SELECT COUNT(*) as Totalt_Antall FROM dataset;

-- List opp alle unike 'Objektnavn' fra datasettet.
SELECT DISTINCT Objektnavn FROM dataset;

-- Finn den totale estimerte tiden ('Est') for alle jobbtyper 'Korrigerande'.
SELECT SUM(Est) as Total_Estimert_Tid FROM dataset WHERE Jobbtype = 'Korrigerande';

-- Finne den totale faktisk brukte "Fakt" for alle jobbtyper
SELECT sum(Fakt) as Total_faktisk_tid FROM dataset WHERE Jobbtype = 'Korrigerande';

-- Hent alle oppføringer der 'Status' er 'Ferdigmeldt' og 'Fakt' er mindre enn 'Est'.
SELECT * FROM dataset WHERE Status = 'Ferdigmeldt' AND Fakt < Est;

-- List opp alle forskjellige 'Utførande' individer og antallet oppgaver de har.
SELECT Utførande, COUNT(*) as Antall_Oppgaver FROM dataset GROUP BY Utførande;

-- Finn oppgavene der 'AO_tekst' nevner 'diesel'.
SELECT * FROM dataset WHERE AO_tekst LIKE '%diesel%';

-- Få gjennomsnittlig estimert tid ('Est') for hver 'Fag' type.
SELECT Fag, AVG(Est) as Gjennomsnitt_Estimert_Tid FROM dataset GROUP BY Fag;

-- Finn oppføringer der 'Ferdig' dato er før 'Pl_ferdig' dato.
SELECT * FROM dataset WHERE Ferdig < Pl_ferdig;

-- Tell hvor mange oppføringer som mangler eller har NULL i 'Fag' kolonnen.
SELECT COUNT(*) as Manglende_Fag_Antall FROM dataset WHERE Fag IS NULL OR TRIM(Fag) = '';

-- Hent oppgavene som ble fullført ('Ferdig') i september 2021.
SELECT * FROM dataset WHERE MONTH(Ferdig) = 9 AND YEAR(Ferdig) = 2021;


### Oppgaver
-- ENKLE OPPGAVER:

-- Oppgave 1: Tell antall unike objekter basert på 'Objektnavn'.
-- Hensikt: Introdusere COUNT og DISTINCT funksjonene.
SELECT COUNT(DISTINCT Objektnavn) as Antall_Unike_Objekter FROM dataset;
-- Fasit: En verdi som representerer antall unike objektnavn.

-- Oppgave 2: Hent alle oppgaver som ble utført av 'vakt_mekanisk'.
-- Hensikt: Introdusere WHERE klausulen.
SELECT * FROM dataset WHERE Utførande = 'vakt_mekanisk';
-- Fasit: Alle rader hvor Utførande er 'vakt_mekanisk'.

-- Oppgave 3: Finn den totale estimerte tiden for alle oppgaver.
-- Hensikt: Introdusere SUM funksjonen.
SELECT SUM(Est) as Total_Estimert_Tid FROM dataset;
-- Fasit: En verdi som representerer summen av all estimert tid.

-- Oppgave 4: Hent oppgaver som har status 'Ferdigmeldt', men har NULL som ferdig dato.
-- Hensikt: Introdusere kombinasjon av WHERE klausulen med AND og IS NULL.
SELECT * FROM dataset WHERE Status = 'Ferdigmeldt' AND Ferdig IS NULL;
-- Fasit: Alle rader med status 'Ferdigmeldt' og null i Ferdig kolonnen.

-- Oppgave 5: List opp alle forskjellige 'Jobbtype'.
-- Hensikt: Introdusere DISTINCT funksjonen.
SELECT DISTINCT Jobbtype FROM dataset;
-- Fasit: En liste over alle unike jobbtyper.

-- MELLOM NIVÅ:

-- Oppgave 6: Hvilken 'Utførande' har fullført flest oppgaver?
-- Hensikt: Introdusere GROUP BY, COUNT og ORDER BY.
SELECT Utførande, COUNT(*) as Antall_Oppgaver FROM dataset GROUP BY Utførande ORDER BY Antall_Oppgaver DESC LIMIT 1;
-- Fasit: Utførande med høyest antall oppgaver.

-- Oppgave 7: Hvilke oppgaver hadde en faktisk tid ('Fakt') som var høyere enn den estimerte tiden ('Est')?
-- Hensikt: Introdusere sammenligning av kolonner med WHERE klausulen.
SELECT * FROM dataset WHERE Fakt > Est;
-- Fasit: Alle rader der 'Fakt' er større enn 'Est'.

-- VANSKELIG:

-- Oppgave 8: Finn gjennomsnittlig estimert tid for hver 'Jobbtype', men vis kun de som har en gjennomsnittlig estimert tid større enn 2 timer.
-- Hensikt: Introdusere AVG funksjonen, GROUP BY, og HAVING klausulen.
SELECT Jobbtype, AVG(Est) as Gjennomsnitt_Estimert_Tid FROM dataset GROUP BY Jobbtype HAVING Gjennomsnitt_Estimert_Tid > 2;
-- Fasit: En liste over jobbtyper med deres gjennomsnittlige estimerte tid, filtrert for å bare vise de over 2 timer.


    

