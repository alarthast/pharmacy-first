-- Run query 001 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_1 AS SELECT anon_1.patient_id AS patient_id 
FROM (SELECT practice_registrations.patient_id AS patient_id, row_number() OVER (PARTITION BY practice_registrations.patient_id ORDER BY practice_registrations.start_date DESC) AS anon_2 
FROM (
        SELECT
            patient_id AS patient_id,
            CAST(registration_start_datetime AS date) AS start_date,
            CAST(registration_end_datetime AS date) AS end_date
        FROM patient
        ) AS practice_registrations 
WHERE practice_registrations.start_date <= '2025-01-31' AND (practice_registrations.end_date >= '2025-01-31' OR practice_registrations.end_date IS NULL)) AS anon_1 
WHERE anon_1.anon_2 = 1;

-- Run query 002 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_2 AS SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_1.patient_id AS patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_1 UNION SELECT patients.patient_id AS patient_id 
FROM (
        SELECT
            patient_id AS patient_id,
            CAST(date_of_birth AS date) AS date_of_birth,
            CASE
                WHEN sex = 'M' THEN 'male'
                WHEN sex = 'F' THEN 'female'
                WHEN sex = 'I' THEN 'intersex'
                ELSE 'unknown'
            END AS sex,
            CAST(date_of_death AS date) AS date_of_death
        FROM patient
        ) AS patients UNION SELECT t1oo.patient_id AS patient_id 
FROM (
        SELECT
            patient_id
        FROM patient
        WHERE
            is_consent_9nu0 = false
        ) AS t1oo UNION SELECT ndoo.patient_id AS patient_id 
FROM (
        SELECT
            patient_id
        FROM patient
        WHERE
            is_national_data_opted_in = false
        ) AS ndoo;

-- Run query 003 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_3 AS SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_2.patient_id AS patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_2 LEFT OUTER JOIN ehrql_20261014_1919_8ccb7b1a54cc_tmp_1 ON ehrql_20261014_1919_8ccb7b1a54cc_tmp_1.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_2.patient_id LEFT OUTER JOIN (
        SELECT
            patient_id AS patient_id,
            CAST(date_of_birth AS date) AS date_of_birth,
            CASE
                WHEN sex = 'M' THEN 'male'
                WHEN sex = 'F' THEN 'female'
                WHEN sex = 'I' THEN 'intersex'
                ELSE 'unknown'
            END AS sex,
            CAST(date_of_death AS date) AS date_of_death
        FROM patient
        ) AS patients ON patients.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_2.patient_id LEFT OUTER JOIN (
        SELECT
            patient_id
        FROM patient
        WHERE
            is_consent_9nu0 = false
        ) AS t1oo ON t1oo.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_2.patient_id LEFT OUTER JOIN (
        SELECT
            patient_id
        FROM patient
        WHERE
            is_national_data_opted_in = false
        ) AS ndoo ON ndoo.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_2.patient_id 
WHERE ehrql_20261014_1919_8ccb7b1a54cc_tmp_1.patient_id IS NOT NULL AND patients.sex IN ('female', 'male') AND t1oo.patient_id IS NULL AND ndoo.patient_id IS NULL;

-- Run query 004 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_1;

-- Run query 005 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_2;

-- Run query 006 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_8 AS SELECT clinical_events.patient_id AS patient_id, clinical_events.consultation_id AS value 
FROM (
        SELECT
            patient_id,
            CAST(effective_datetime AS date) as date,
            CAST(snomed_concept_id AS varchar) AS snomedct_code,
            CAST(numeric_value AS real) AS numeric_value,
            consultation_id
        FROM observation
        ) AS clinical_events 
WHERE clinical_events.date >= '2024-01-31' AND clinical_events.date <= '2025-01-31' AND clinical_events.snomedct_code IN ('1577041000000109', '983341000000102', '2129921000000100') AND clinical_events.patient_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3) AND clinical_events.consultation_id IS NOT NULL;

-- Run query 007 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_15 AS SELECT DISTINCT clinical_events.patient_id AS patient_id 
FROM (
        SELECT
            patient_id,
            CAST(effective_datetime AS date) as date,
            CAST(snomed_concept_id AS varchar) AS snomedct_code,
            CAST(numeric_value AS real) AS numeric_value,
            consultation_id
        FROM observation
        ) AS clinical_events 
WHERE clinical_events.date >= '2024-01-31' AND clinical_events.date <= '2025-01-31' AND clinical_events.consultation_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.value 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_8 
WHERE ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.patient_id = clinical_events.patient_id) AND clinical_events.snomedct_code IN ('48277006') AND clinical_events.patient_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3);

-- Run query 008 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_14 AS SELECT DISTINCT clinical_events.patient_id AS patient_id 
FROM (
        SELECT
            patient_id,
            CAST(effective_datetime AS date) as date,
            CAST(snomed_concept_id AS varchar) AS snomedct_code,
            CAST(numeric_value AS real) AS numeric_value,
            consultation_id
        FROM observation
        ) AS clinical_events 
WHERE clinical_events.date >= '2024-01-31' AND clinical_events.date <= '2025-01-31' AND clinical_events.consultation_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.value 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_8 
WHERE ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.patient_id = clinical_events.patient_id) AND clinical_events.snomedct_code IN ('4740000') AND clinical_events.patient_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3);

-- Run query 009 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_13 AS SELECT DISTINCT clinical_events.patient_id AS patient_id 
FROM (
        SELECT
            patient_id,
            CAST(effective_datetime AS date) as date,
            CAST(snomed_concept_id AS varchar) AS snomedct_code,
            CAST(numeric_value AS real) AS numeric_value,
            consultation_id
        FROM observation
        ) AS clinical_events 
WHERE clinical_events.date >= '2024-01-31' AND clinical_events.date <= '2025-01-31' AND clinical_events.consultation_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.value 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_8 
WHERE ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.patient_id = clinical_events.patient_id) AND clinical_events.snomedct_code IN ('363746003') AND clinical_events.patient_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3);

-- Run query 010 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_12 AS SELECT DISTINCT clinical_events.patient_id AS patient_id 
FROM (
        SELECT
            patient_id,
            CAST(effective_datetime AS date) as date,
            CAST(snomed_concept_id AS varchar) AS snomedct_code,
            CAST(numeric_value AS real) AS numeric_value,
            consultation_id
        FROM observation
        ) AS clinical_events 
WHERE clinical_events.date >= '2024-01-31' AND clinical_events.date <= '2025-01-31' AND clinical_events.consultation_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.value 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_8 
WHERE ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.patient_id = clinical_events.patient_id) AND clinical_events.snomedct_code IN ('3110003') AND clinical_events.patient_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3);

-- Run query 011 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_11 AS SELECT DISTINCT clinical_events.patient_id AS patient_id 
FROM (
        SELECT
            patient_id,
            CAST(effective_datetime AS date) as date,
            CAST(snomed_concept_id AS varchar) AS snomedct_code,
            CAST(numeric_value AS real) AS numeric_value,
            consultation_id
        FROM observation
        ) AS clinical_events 
WHERE clinical_events.date >= '2024-01-31' AND clinical_events.date <= '2025-01-31' AND clinical_events.consultation_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.value 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_8 
WHERE ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.patient_id = clinical_events.patient_id) AND clinical_events.snomedct_code IN ('262550002') AND clinical_events.patient_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3);

-- Run query 012 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_10 AS SELECT DISTINCT clinical_events.patient_id AS patient_id 
FROM (
        SELECT
            patient_id,
            CAST(effective_datetime AS date) as date,
            CAST(snomed_concept_id AS varchar) AS snomedct_code,
            CAST(numeric_value AS real) AS numeric_value,
            consultation_id
        FROM observation
        ) AS clinical_events 
WHERE clinical_events.date >= '2024-01-31' AND clinical_events.date <= '2025-01-31' AND clinical_events.consultation_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.value 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_8 
WHERE ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.patient_id = clinical_events.patient_id) AND clinical_events.snomedct_code IN ('15805002') AND clinical_events.patient_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3);

-- Run query 013 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_9 AS SELECT DISTINCT clinical_events.patient_id AS patient_id 
FROM (
        SELECT
            patient_id,
            CAST(effective_datetime AS date) as date,
            CAST(snomed_concept_id AS varchar) AS snomedct_code,
            CAST(numeric_value AS real) AS numeric_value,
            consultation_id
        FROM observation
        ) AS clinical_events 
WHERE clinical_events.date >= '2024-01-31' AND clinical_events.date <= '2025-01-31' AND clinical_events.consultation_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.value 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_8 
WHERE ehrql_20261014_1919_8ccb7b1a54cc_tmp_8.patient_id = clinical_events.patient_id) AND clinical_events.snomedct_code IN ('1090711000000102') AND clinical_events.patient_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3);

-- Run query 014 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_8;

-- Run query 015 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (
	value VARCHAR
);

-- Run query 016 / 032
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275588005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('445343003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978021000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('47327008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('110791000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('88790004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('651601000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154215006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185990008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154182006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('10432001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('46723002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977441000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('661741000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('59366001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976721000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976981000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186039002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977831000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('79434006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('56056003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('63732001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('393199009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('76574004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('77686000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('1340002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976671000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94041000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976831000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977881000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('37474002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92521000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('394635008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('13440006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977951000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('18583004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('88941000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185985005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154185008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976791000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('83939006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94071000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154195001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('17789004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('1036211000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154188005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('73524008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185997006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275591005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('367505005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('24812003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978391000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186029008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154176008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186043003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('23517005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('704388000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('81653003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92501000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('52075006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('270463003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978201000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977351000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186040000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('9158000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('494131000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('89011000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315634007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154170002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275601009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186022004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('18575005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('69983001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('63736003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275602002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('28796001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185989004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('413466005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('270462008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('270465005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('67165000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978071000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977971000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186030003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('18167009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92591000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976941000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('21993009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('88981000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154165009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94091000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92781000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275586009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978381000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('401214002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275594002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('83584002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('82174001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154216007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('414481008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('50405005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('21047009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('19085009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154224002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977791000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('55990000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275595001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('414752008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('60157000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92511000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('73736004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154179001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('110751000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('733078003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('113170005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978211000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('710011000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977371000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('704385002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('270460000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92411000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315238004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('704391000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186000006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('88911000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('14176005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('718021000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('41076003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978261000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('66406004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94111000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('51750002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('80208004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('108342005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('110781000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186023009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('40182006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('76253004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('91191002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154203007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186047002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('718958002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('413569000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978081000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154200005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('309644006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977981000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('401213008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186017004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976951000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('91488008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('704389008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('25750005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154209006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('718959005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977561000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186037000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('63457007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978251000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154206004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94151000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('93951000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977761000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92741000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('668681000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('718963003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('82121000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('81283004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186018009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('66920001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977601000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185987002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('110771000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185998001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('43056000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('14470009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('414152003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94051000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977431000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977401000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976731000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('11794009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92441000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186012005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('72809004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186005001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('88839008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('583481000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977751000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92581000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186010002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('270464009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('53195006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976631000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('43608005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186015007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186031004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315283003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('75326007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154164008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('296841000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('65776006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('69865008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977721000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154194002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976781000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186025002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('28562006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154226000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92681000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('704386001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('733446001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('521000220104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('88971000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275597009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976651000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('88934004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('93981000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('64483007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('21868006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('735001008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186036009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92401000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('309643000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('394149000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154223008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315280000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('81846005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92641000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('59597001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976641000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('85371009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('270466006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94081000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('88961000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92391000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('90348007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978041000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315282008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('81035008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154197009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92491000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154214005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186041001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154167001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976871000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('113169009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('494161000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978231000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('28821007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('32045009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92481000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('45465003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('704390004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('76768002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('494141000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('80528001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('28409002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186048007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977361000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186026001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94121000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('666871000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94101000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186003008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92571000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('48294008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('85515006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976961000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('27301002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('72248007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978181000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('110401000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('494171000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978191000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92541000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315281001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('718960000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154207008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('18664001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976701000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92701000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('90027003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('107691000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('71949006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185986006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976801000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977421000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976691000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('93991000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977801000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94031000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315635008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('72337002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978011000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978241000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('59487007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976841000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186020007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('67439005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('88921000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('160531006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('47250000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('110761000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94021000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186019001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('64693008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('75301003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92471000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('1036361000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186024003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('68486007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154202002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('518701000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978371000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185984009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185996002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978411000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978061000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92661000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92611000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154225001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186016008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('35007000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315237009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976921000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('53460002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('76460008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315240009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154160004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('76883002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('57405008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154193008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('90822005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315239007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('38144004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('81560001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978031000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('85163001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154175007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976821000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92691000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('89001000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976811000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185995003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('41798002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('46110004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('1036341000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('44891000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('8124001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('71176007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('38750003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186004002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('75704009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('870448005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186035008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186044009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('14999008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('1919006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92731000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275599007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92561000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('3818007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978051000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('76775001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154198004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('81403004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94001000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978121000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154219000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185992000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978271000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('44460002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154190006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154208003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186011003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('3698008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('89026003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154169003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('91066000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154166005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154227009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('718961001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('2852001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92651000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('4299001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('3353005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('38361009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185994004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154181004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('39764005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('23922002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('704387005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('33182009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275592003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92751000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976851000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977551000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154191005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('89021000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('286009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('14045001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('1036281000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275600005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92421000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154180003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275593008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154212009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976711000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92771000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('10117001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('93961000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('19434008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185988007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154213004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186007009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('27700004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154218008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154173000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('88951000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976661000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976931000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('20140003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154220006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('88931000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('87323008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154187000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('7695005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154222003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('58047002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('48375000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('413465009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('43481000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('1036321000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('592501000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92711000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('77502007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275589002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('33897005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('41121000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978401000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('1036251000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('414978006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976901000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154192003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185999009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977731000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('312859007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('62598008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186021006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154161000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('10008004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977811000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977931000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976911000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154196000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978171000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('25804004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('20291009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977941000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315279003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('43890005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154189002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154199007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('2688009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186042008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('494151000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('49202008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186002003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('31637002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185991007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186013000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('86461000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('270467002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('48679001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('40165009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('26215007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186008004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154168006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978281000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('17095009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('718131000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('32513008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92791000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976771000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977821000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('413773004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978351000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977381000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('74302004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154174006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977591000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('519681000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('77711000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154172005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977781000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('718962008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92761000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('414551003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('23534002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('15801006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976741000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186032006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154184007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977711000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('2720008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275596000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('32873005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94011000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154221005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977411000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976891000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186009007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275587000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92601000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92721000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('44881000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('185993005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('661731000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976751000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977961000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92551000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154201009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92431000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('13233008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('1451003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('12556008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186006000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('29343004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('15086000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92671000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('494181000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('83365001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154163002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('36329002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154186009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154162007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('34334001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977391000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186046006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('57539009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('20449009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('1036301000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('6373008');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978361000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92461000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('270461001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('704392007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('10292001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('94061000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186014006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92451000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977861000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977871000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('86275006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('67931002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('27683006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('22007004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186001005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('93931000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977911000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92631000000103');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('4073004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154183001');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('275590006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154178009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977841000000106');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976881000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('9533000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978111000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977851000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154171003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('42632009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('718964009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977741000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('74159009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('72201005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978341000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('113171009');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('186045005');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('93921000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('978221000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('518721000000107');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977771000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('92621000000100');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154177004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976681000000102');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154229007');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('592491000000104');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('93941000000108');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('315236000');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976861000000105');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('37843006');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976761000000101');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('414661004');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('977921000000109');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('154217003');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('48118002');
INSERT INTO ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6 (value) VALUES ('976971000000106');

-- Run query 017 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_7 AS SELECT anon_1.patient_id AS patient_id, anon_1.snomedct_code AS snomedct_code 
FROM (SELECT clinical_events.patient_id AS patient_id, clinical_events.snomedct_code AS snomedct_code, row_number() OVER (PARTITION BY clinical_events.patient_id ORDER BY clinical_events.date DESC, clinical_events.snomedct_code DESC) AS anon_2 
FROM (
        SELECT
            patient_id,
            CAST(effective_datetime AS date) as date,
            CAST(snomed_concept_id AS varchar) AS snomedct_code,
            CAST(numeric_value AS real) AS numeric_value,
            consultation_id
        FROM observation
        ) AS clinical_events 
WHERE clinical_events.snomedct_code IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6.value 
FROM ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6) AND clinical_events.date <= '2025-01-31' AND clinical_events.patient_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3)) AS anon_1 
WHERE anon_1.anon_2 = 1;

-- Run query 018 / 032
DROP TABLE ehrql_20261014_1919_8ccb7b1a54cc_inline_data_6;

-- Run query 019 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_5 AS SELECT anon_1.patient_id AS patient_id, anon_1.imd_rounded_2019 AS imd_rounded_2019, anon_1.msoa_code_2011 AS msoa_code_2011 
FROM (SELECT addresses.patient_id AS patient_id, addresses.imd_rounded_2019 AS imd_rounded_2019, addresses.msoa_code_2011 AS msoa_code_2011, row_number() OVER (PARTITION BY addresses.patient_id ORDER BY addresses.start_date DESC, addresses.imd_rounded_2019 DESC, addresses.msoa_code_2011 DESC) AS anon_2 
FROM (
        SELECT
            patient_id AS patient_id,
            CAST(registration_start_datetime AS date) AS start_date,
            CAST(registration_end_datetime AS date) AS end_date,
            CAST(imd_rounded_2011 AS int) AS imd_rounded_2019,
            CAST(imd_rounded_2021 AS int) AS imd_rounded_2025,
            index_of_multiple_deprivation_decile_2011 AS imd_decile_2019,
            index_of_multiple_deprivation_decile_2021 AS imd_decile_2025,
            middle_level_super_output_area_code_2011 AS msoa_code_2011,
            middle_level_super_output_area_code_2021 AS msoa_code_2021
        FROM patient
        ) AS addresses 
WHERE addresses.start_date <= '2025-01-31' AND (addresses.end_date >= '2025-01-31' OR CASE WHEN (addresses.end_date < '2025-01-31') THEN true WHEN (addresses.end_date >= '2025-01-31') THEN false END IS NULL) AND addresses.patient_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3)) AS anon_1 
WHERE anon_1.anon_2 = 1;

-- Run query 020 / 032
CREATE TABLE ehrql_20261014_1919_8ccb7b1a54cc_tmp_4 AS SELECT DISTINCT clinical_events.patient_id AS patient_id 
FROM (
        SELECT
            patient_id,
            CAST(effective_datetime AS date) as date,
            CAST(snomed_concept_id AS varchar) AS snomedct_code,
            CAST(numeric_value AS real) AS numeric_value,
            consultation_id
        FROM observation
        ) AS clinical_events 
WHERE clinical_events.date >= '2024-01-31' AND clinical_events.date <= '2025-01-31' AND clinical_events.snomedct_code IN ('1577041000000109', '983341000000102', '2129921000000100') AND clinical_events.patient_id IN (SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3);

-- Fetch results from query 021 / 032
SELECT ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id, CASE WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_4.patient_id IS NOT NULL) THEN true WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_4.patient_id IS NULL) THEN false END AS has_pf_consultation, patients.sex AS sex, (YEAR('2025-01-31') - YEAR(patients.date_of_birth)) - CASE WHEN ((MONTH('2025-01-31') - MONTH(patients.date_of_birth)) * -31 > DAY('2025-01-31') - DAY(patients.date_of_birth)) THEN 1 ELSE 0 END AS age, CASE WHEN ((YEAR('2025-01-31') - YEAR(patients.date_of_birth)) - CASE WHEN ((MONTH('2025-01-31') - MONTH(patients.date_of_birth)) * -31 > DAY('2025-01-31') - DAY(patients.date_of_birth)) THEN 1 ELSE 0 END >= 0 AND (YEAR('2025-01-31') - YEAR(patients.date_of_birth)) - CASE WHEN ((MONTH('2025-01-31') - MONTH(patients.date_of_birth)) * -31 > DAY('2025-01-31') - DAY(patients.date_of_birth)) THEN 1 ELSE 0 END < 20) THEN '0-19' WHEN ((YEAR('2025-01-31') - YEAR(patients.date_of_birth)) - CASE WHEN ((MONTH('2025-01-31') - MONTH(patients.date_of_birth)) * -31 > DAY('2025-01-31') - DAY(patients.date_of_birth)) THEN 1 ELSE 0 END >= 20 AND (YEAR('2025-01-31') - YEAR(patients.date_of_birth)) - CASE WHEN ((MONTH('2025-01-31') - MONTH(patients.date_of_birth)) * -31 > DAY('2025-01-31') - DAY(patients.date_of_birth)) THEN 1 ELSE 0 END < 40) THEN '20-39' WHEN ((YEAR('2025-01-31') - YEAR(patients.date_of_birth)) - CASE WHEN ((MONTH('2025-01-31') - MONTH(patients.date_of_birth)) * -31 > DAY('2025-01-31') - DAY(patients.date_of_birth)) THEN 1 ELSE 0 END >= 40 AND (YEAR('2025-01-31') - YEAR(patients.date_of_birth)) - CASE WHEN ((MONTH('2025-01-31') - MONTH(patients.date_of_birth)) * -31 > DAY('2025-01-31') - DAY(patients.date_of_birth)) THEN 1 ELSE 0 END < 60) THEN '40-59' WHEN ((YEAR('2025-01-31') - YEAR(patients.date_of_birth)) - CASE WHEN ((MONTH('2025-01-31') - MONTH(patients.date_of_birth)) * -31 > DAY('2025-01-31') - DAY(patients.date_of_birth)) THEN 1 ELSE 0 END >= 60 AND (YEAR('2025-01-31') - YEAR(patients.date_of_birth)) - CASE WHEN ((MONTH('2025-01-31') - MONTH(patients.date_of_birth)) * -31 > DAY('2025-01-31') - DAY(patients.date_of_birth)) THEN 1 ELSE 0 END < 80) THEN '60-79' WHEN ((YEAR('2025-01-31') - YEAR(patients.date_of_birth)) - CASE WHEN ((MONTH('2025-01-31') - MONTH(patients.date_of_birth)) * -31 > DAY('2025-01-31') - DAY(patients.date_of_birth)) THEN 1 ELSE 0 END >= 80) THEN '80+' WHEN ((YEAR('2025-01-31') - YEAR(patients.date_of_birth)) - CASE WHEN ((MONTH('2025-01-31') - MONTH(patients.date_of_birth)) * -31 > DAY('2025-01-31') - DAY(patients.date_of_birth)) THEN 1 ELSE 0 END IS NULL) THEN 'Missing' END AS age_band, ehrql_20261014_1919_8ccb7b1a54cc_tmp_5.msoa_code_2011 AS msoa_code, CASE WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_5.imd_rounded_2019 >= 0 AND ehrql_20261014_1919_8ccb7b1a54cc_tmp_5.imd_rounded_2019 < 6568) THEN '1 (Most Deprived)' WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_5.imd_rounded_2019 < 13137) THEN '2' WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_5.imd_rounded_2019 < 19706) THEN '3' WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_5.imd_rounded_2019 < 26275) THEN '4' WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_5.imd_rounded_2019 <= 32844) THEN '5 (Least Deprived)' ELSE 'Missing' END AS imd, coalesce(CASE CASE ehrql_20261014_1919_8ccb7b1a54cc_tmp_7.snomedct_code WHEN '10292001' THEN '16' WHEN '108342005' THEN '16' WHEN '113170005' THEN '16' WHEN '113171009' THEN '16' WHEN '13233008' THEN '16' WHEN '154182006' THEN '16' WHEN '154183001' THEN '16' WHEN '154184007' THEN '16' WHEN '154186009' THEN '16' WHEN '154195001' THEN '16' WHEN '154203007' THEN '16' WHEN '154209006' THEN '16' WHEN '154212009' THEN '16' WHEN '154215006' THEN '16' WHEN '154216007' THEN '16' WHEN '154217003' THEN '16' WHEN '154218008' THEN '16' WHEN '154219000' THEN '16' WHEN '154220006' THEN '16' WHEN '154221005' THEN '16' WHEN '154222003' THEN '16' WHEN '154227009' THEN '16' WHEN '154229007' THEN '16' WHEN '15801006' THEN '16' WHEN '17789004' THEN '16' WHEN '18575005' THEN '16' WHEN '186005001' THEN '16' WHEN '186006000' THEN '16' WHEN '186007009' THEN '16' WHEN '186009007' THEN '16' WHEN '186018009' THEN '16' WHEN '186026001' THEN '16' WHEN '186032006' THEN '16' WHEN '186035008' THEN '16' WHEN '186037000' THEN '16' WHEN '186039002' THEN '16' WHEN '186040000' THEN '16' WHEN '186041001' THEN '16' WHEN '186042008' THEN '16' WHEN '186043003' THEN '16' WHEN '186047002' THEN '16' WHEN '186048007' THEN '16' WHEN '18664001' THEN '16' WHEN '19085009' THEN '16' WHEN '20140003' THEN '16' WHEN '20291009' THEN '16' WHEN '21047009' THEN '16' WHEN '22007004' THEN '16' WHEN '23517005' THEN '16' WHEN '23534002' THEN '16' WHEN '25750005' THEN '16' WHEN '270464009' THEN '16' WHEN '27301002' THEN '16' WHEN '275594002' THEN '16' WHEN '275595001' THEN '16' WHEN '27700004' THEN '16' WHEN '28821007' THEN '16' WHEN '296841000000102' THEN '16' WHEN '312859007' THEN '16' WHEN '315282008' THEN '16' WHEN '32873005' THEN '16' WHEN '33182009' THEN '16' WHEN '3353005' THEN '16' WHEN '34334001' THEN '16' WHEN '35007000' THEN '16' WHEN '3698008' THEN '16' WHEN '38144004' THEN '16' WHEN '38361009' THEN '16' WHEN '38750003' THEN '16' WHEN '4073004' THEN '16' WHEN '413569000' THEN '16' WHEN '414661004' THEN '16' WHEN '41798002' THEN '16' WHEN '43056000' THEN '16' WHEN '43608005' THEN '16' WHEN '43890005' THEN '16' WHEN '47327008' THEN '16' WHEN '48118002' THEN '16' WHEN '48294008' THEN '16' WHEN '48375000' THEN '16' WHEN '49202008' THEN '16' WHEN '50405005' THEN '16' WHEN '55990000' THEN '16' WHEN '57539009' THEN '16' WHEN '583481000000105' THEN '16' WHEN '592491000000104' THEN '16' WHEN '592501000000105' THEN '16' WHEN '59487007' THEN '16' WHEN '59597001' THEN '16' WHEN '60157000' THEN '16' WHEN '62598008' THEN '16' WHEN '63457007' THEN '16' WHEN '6373008' THEN '16' WHEN '63732001' THEN '16' WHEN '65776006' THEN '16' WHEN '661731000000107' THEN '16' WHEN '66406004' THEN '16' WHEN '666871000000107' THEN '16' WHEN '66920001' THEN '16' WHEN '67931002' THEN '16' WHEN '69865008' THEN '16' WHEN '69983001' THEN '16' WHEN '71949006' THEN '16' WHEN '72337002' THEN '16' WHEN '73524008' THEN '16' WHEN '73736004' THEN '16' WHEN '74159009' THEN '16' WHEN '74302004' THEN '16' WHEN '75301003' THEN '16' WHEN '75326007' THEN '16' WHEN '75704009' THEN '16' WHEN '76460008' THEN '16' WHEN '76883002' THEN '16' WHEN '77502007' THEN '16' WHEN '77686000' THEN '16' WHEN '79434006' THEN '16' WHEN '81560001' THEN '16' WHEN '81653003' THEN '16' WHEN '85515006' THEN '16' WHEN '86275006' THEN '16' WHEN '87323008' THEN '16' WHEN '89001000000105' THEN '16' WHEN '89011000000107' THEN '16' WHEN '89021000000101' THEN '16' WHEN '89026003' THEN '16' WHEN '90027003' THEN '16' WHEN '91488008' THEN '16' WHEN '92521000000101' THEN '16' WHEN '94071000000100' THEN '16' WHEN '94081000000103' THEN '16' WHEN '94091000000101' THEN '16' WHEN '94101000000109' THEN '16' WHEN '94111000000106' THEN '16' WHEN '94121000000100' THEN '16' WHEN '94151000000105' THEN '16' WHEN '976951000000102' THEN '16' WHEN '976961000000104' THEN '16' WHEN '976971000000106' THEN '16' WHEN '976981000000108' THEN '16' WHEN '977851000000109' THEN '16' WHEN '977861000000107' THEN '16' WHEN '977871000000100' THEN '16' WHEN '977881000000103' THEN '16' WHEN '978381000000105' THEN '16' WHEN '978391000000107' THEN '16' WHEN '978401000000105' THEN '16' WHEN '978411000000107' THEN '16' WHEN '154181004' THEN '15' WHEN '154224002' THEN '15' WHEN '186004002' THEN '15' WHEN '33897005' THEN '15' WHEN '92511000000107' THEN '15' WHEN '976851000000107' THEN '15' WHEN '977751000000101' THEN '15' WHEN '978191000000109' THEN '15' WHEN '976861000000105' THEN '15' WHEN '977761000000103' THEN '15' WHEN '978201000000106' THEN '15' WHEN '110791000000100' THEN '14' WHEN '15086000' THEN '14' WHEN '154166005' THEN '14' WHEN '154167001' THEN '14' WHEN '154169003' THEN '14' WHEN '154171003' THEN '14' WHEN '154172005' THEN '14' WHEN '154173000' THEN '14' WHEN '154174006' THEN '14' WHEN '154206004' THEN '14' WHEN '185989004' THEN '14' WHEN '185990008' THEN '14' WHEN '185992000' THEN '14' WHEN '185994004' THEN '14' WHEN '185995003' THEN '14' WHEN '185996002' THEN '14' WHEN '185997006' THEN '14' WHEN '186029008' THEN '14' WHEN '270461001' THEN '14' WHEN '270462008' THEN '14' WHEN '275587000' THEN '14' WHEN '275588005' THEN '14' WHEN '275589002' THEN '14' WHEN '275590006' THEN '14' WHEN '315240009' THEN '14' WHEN '315279003' THEN '14' WHEN '651601000000100' THEN '14' WHEN '92501000000105' THEN '14' WHEN '92741000000104' THEN '14' WHEN '976931000000109' THEN '14' WHEN '977831000000102' THEN '14' WHEN '978271000000103' THEN '14' WHEN '978341000000102' THEN '14' WHEN '978361000000101' THEN '14' WHEN '976941000000100' THEN '14' WHEN '978371000000108' THEN '14' WHEN '977841000000106' THEN '14' WHEN '978351000000104' THEN '14' WHEN '521000220104' THEN '14' WHEN '10008004' THEN '13' WHEN '11794009' THEN '13' WHEN '13440006' THEN '13' WHEN '14470009' THEN '13' WHEN '154165009' THEN '13' WHEN '154170002' THEN '13' WHEN '154187000' THEN '13' WHEN '18167009' THEN '13' WHEN '185993005' THEN '13' WHEN '186010002' THEN '13' WHEN '1919006' THEN '13' WHEN '21868006' THEN '13' WHEN '23922002' THEN '13' WHEN '2720008' THEN '13' WHEN '275586009' THEN '13' WHEN '37474002' THEN '13' WHEN '37843006' THEN '13' WHEN '3818007' THEN '13' WHEN '39764005' THEN '13' WHEN '41076003' THEN '13' WHEN '46110004' THEN '13' WHEN '51750002' THEN '13' WHEN '52075006' THEN '13' WHEN '58047002' THEN '13' WHEN '59366001' THEN '13' WHEN '67439005' THEN '13' WHEN '71176007' THEN '13' WHEN '72201005' THEN '13' WHEN '72248007' THEN '13' WHEN '76253004' THEN '13' WHEN '76775001' THEN '13' WHEN '80528001' THEN '13' WHEN '8124001' THEN '13' WHEN '82174001' THEN '13' WHEN '83584002' THEN '13' WHEN '85371009' THEN '13' WHEN '870448005' THEN '13' WHEN '88790004' THEN '13' WHEN '88839008' THEN '13' WHEN '88934004' THEN '13' WHEN '90822005' THEN '13' WHEN '9158000' THEN '13' WHEN '92491000000104' THEN '13' WHEN '92711000000100' THEN '13' WHEN '92731000000108' THEN '13' WHEN '94061000000107' THEN '13' WHEN '976891000000104' THEN '13' WHEN '977791000000109' THEN '13' WHEN '978231000000100' THEN '13' WHEN '978251000000107' THEN '13' WHEN '978241000000109' THEN '13' WHEN '976901000000103' THEN '13' WHEN '977801000000108' THEN '13' WHEN '978261000000105' THEN '13' WHEN '107691000000105' THEN '12' WHEN '154164008' THEN '12' WHEN '154168006' THEN '12' WHEN '154185008' THEN '12' WHEN '160531006' THEN '12' WHEN '185988007' THEN '12' WHEN '185991007' THEN '12' WHEN '186008004' THEN '12' WHEN '270460000' THEN '12' WHEN '270463003' THEN '12' WHEN '275591005' THEN '12' WHEN '275592003' THEN '12' WHEN '275593008' THEN '12' WHEN '309643000' THEN '12' WHEN '309644006' THEN '12' WHEN '413465009' THEN '12' WHEN '976911000000101' THEN '12' WHEN '977811000000105' THEN '12' WHEN '976921000000107' THEN '12' WHEN '977821000000104' THEN '12' WHEN '978281000000101' THEN '12' WHEN '10432001' THEN '11' WHEN '110781000000102' THEN '11' WHEN '12556008' THEN '11' WHEN '1340002' THEN '11' WHEN '154188005' THEN '11' WHEN '154190006' THEN '11' WHEN '154207008' THEN '11' WHEN '154223008' THEN '11' WHEN '154226000' THEN '11' WHEN '186011003' THEN '11' WHEN '186013000' THEN '11' WHEN '186030003' THEN '11' WHEN '186044009' THEN '11' WHEN '186046006' THEN '11' WHEN '20449009' THEN '11' WHEN '21993009' THEN '11' WHEN '24812003' THEN '11' WHEN '26215007' THEN '11' WHEN '2688009' THEN '11' WHEN '270465005' THEN '11' WHEN '275596000' THEN '11' WHEN '275597009' THEN '11' WHEN '27683006' THEN '11' WHEN '2852001' THEN '11' WHEN '28796001' THEN '11' WHEN '315280000' THEN '11' WHEN '315281001' THEN '11' WHEN '32513008' THEN '11' WHEN '40165009' THEN '11' WHEN '414551003' THEN '11' WHEN '414978006' THEN '11' WHEN '42632009' THEN '11' WHEN '4299001' THEN '11' WHEN '44460002' THEN '11' WHEN '46723002' THEN '11' WHEN '47250000' THEN '11' WHEN '48679001' THEN '11' WHEN '53195006' THEN '11' WHEN '57405008' THEN '11' WHEN '63736003' THEN '11' WHEN '661741000000103' THEN '11' WHEN '67165000' THEN '11' WHEN '704385002' THEN '11' WHEN '704386001' THEN '11' WHEN '704387005' THEN '11' WHEN '704388000' THEN '11' WHEN '704389008' THEN '11' WHEN '704390004' THEN '11' WHEN '704391000' THEN '11' WHEN '704392007' THEN '11' WHEN '718131000000106' THEN '11' WHEN '76768002' THEN '11' WHEN '81283004' THEN '11' WHEN '81846005' THEN '11' WHEN '83365001' THEN '11' WHEN '83939006' THEN '11' WHEN '86461000000107' THEN '11' WHEN '90348007' THEN '11' WHEN '91066000' THEN '11' WHEN '91191002' THEN '11' WHEN '92481000000101' THEN '11' WHEN '92651000000105' THEN '11' WHEN '92661000000108' THEN '11' WHEN '92671000000101' THEN '11' WHEN '92681000000104' THEN '11' WHEN '92691000000102' THEN '11' WHEN '92701000000102' THEN '11' WHEN '92751000000101' THEN '11' WHEN '92761000000103' THEN '11' WHEN '92771000000105' THEN '11' WHEN '92781000000107' THEN '11' WHEN '976871000000103' THEN '11' WHEN '977771000000105' THEN '11' WHEN '978211000000108' THEN '11' WHEN '976881000000101' THEN '11' WHEN '977781000000107' THEN '11' WHEN '978221000000102' THEN '11' WHEN '154180003' THEN '10' WHEN '186003008' THEN '10' WHEN '92471000000103' THEN '10' WHEN '976831000000100' THEN '10' WHEN '977731000000108' THEN '10' WHEN '978171000000105' THEN '10' WHEN '976841000000109' THEN '10' WHEN '977741000000104' THEN '10' WHEN '978181000000107' THEN '10' WHEN '154179001' THEN '9' WHEN '186002003' THEN '9' WHEN '81035008' THEN '9' WHEN '92461000000105' THEN '9' WHEN '976811000000108' THEN '9' WHEN '977711000000100' THEN '9' WHEN '978071000000106' THEN '9' WHEN '978081000000108' THEN '9' WHEN '976821000000102' THEN '9' WHEN '977721000000106' THEN '9' WHEN '110751000000108' THEN '8' WHEN '154178009' THEN '8' WHEN '154189002' THEN '8' WHEN '154225001' THEN '8' WHEN '186001005' THEN '8' WHEN '186012005' THEN '8' WHEN '186045005' THEN '8' WHEN '64483007' THEN '8' WHEN '92641000000107' THEN '8' WHEN '976791000000107' THEN '8' WHEN '977591000000103' THEN '8' WHEN '978111000000100' THEN '8' WHEN '977601000000109' THEN '8' WHEN '976801000000106' THEN '8' WHEN '978121000000106' THEN '8' WHEN '414481008' THEN '8' WHEN '110771000000104' THEN '7' WHEN '154175007' THEN '7' WHEN '154176008' THEN '7' WHEN '154177004' THEN '7' WHEN '154196000' THEN '7' WHEN '154197009' THEN '7' WHEN '154199007' THEN '7' WHEN '154200005' THEN '7' WHEN '185998001' THEN '7' WHEN '185999009' THEN '7' WHEN '186000006' THEN '7' WHEN '186019001' THEN '7' WHEN '186022004' THEN '7' WHEN '186023009' THEN '7' WHEN '315239007' THEN '7' WHEN '92451000000107' THEN '7' WHEN '92581000000100' THEN '7' WHEN '92591000000103' THEN '7' WHEN '92601000000109' THEN '7' WHEN '92611000000106' THEN '7' WHEN '92621000000100' THEN '7' WHEN '92631000000103' THEN '7' WHEN '92721000000106' THEN '7' WHEN '976771000000108' THEN '7' WHEN '976781000000105' THEN '7' WHEN '977551000000106' THEN '7' WHEN '977561000000109' THEN '7' WHEN '978051000000102' THEN '7' WHEN '978061000000104' THEN '7' WHEN '414752008' THEN '7' WHEN '154198004' THEN '6' WHEN '186021006' THEN '6' WHEN '92441000000109' THEN '6' WHEN '976751000000104' THEN '6' WHEN '976761000000101' THEN '6' WHEN '977431000000100' THEN '6' WHEN '977441000000109' THEN '6' WHEN '154202002' THEN '5' WHEN '186025002' THEN '5' WHEN '315635008' THEN '5' WHEN '413466005' THEN '5' WHEN '92431000000100' THEN '5' WHEN '976731000000106' THEN '5' WHEN '976741000000102' THEN '5' WHEN '977411000000108' THEN '5' WHEN '977421000000102' THEN '5' WHEN '154201009' THEN '4' WHEN '186020007' THEN '4' WHEN '186024003' THEN '4' WHEN '315634007' THEN '4' WHEN '92421000000102' THEN '4' WHEN '976711000000103' THEN '4' WHEN '976721000000109' THEN '4' WHEN '977391000000108' THEN '4' WHEN '977401000000106' THEN '4' WHEN '10117001' THEN '3' WHEN '1036211000000103' THEN '3' WHEN '1036251000000104' THEN '3' WHEN '1036281000000105' THEN '3' WHEN '1036301000000106' THEN '3' WHEN '1036321000000102' THEN '3' WHEN '1036341000000109' THEN '3' WHEN '1036361000000105' THEN '3' WHEN '110401000000103' THEN '3' WHEN '113169009' THEN '3' WHEN '14045001' THEN '3' WHEN '14176005' THEN '3' WHEN '1451003' THEN '3' WHEN '154163002' THEN '3' WHEN '154192003' THEN '3' WHEN '154193008' THEN '3' WHEN '154194002' THEN '3' WHEN '154208003' THEN '3' WHEN '154213004' THEN '3' WHEN '154214005' THEN '3' WHEN '17095009' THEN '3' WHEN '18583004' THEN '3' WHEN '185984009' THEN '3' WHEN '185987002' THEN '3' WHEN '186015007' THEN '3' WHEN '186016008' THEN '3' WHEN '186017004' THEN '3' WHEN '186031004' THEN '3' WHEN '186036009' THEN '3' WHEN '19434008' THEN '3' WHEN '270466006' THEN '3' WHEN '270467002' THEN '3' WHEN '275599007' THEN '3' WHEN '275600005' THEN '3' WHEN '275601009' THEN '3' WHEN '275602002' THEN '3' WHEN '28409002' THEN '3' WHEN '28562006' THEN '3' WHEN '286009' THEN '3' WHEN '29343004' THEN '3' WHEN '315238004' THEN '3' WHEN '315283003' THEN '3' WHEN '31637002' THEN '3' WHEN '32045009' THEN '3' WHEN '36329002' THEN '3' WHEN '367505005' THEN '3' WHEN '393199009' THEN '3' WHEN '394149000' THEN '3' WHEN '394635008' THEN '3' WHEN '40182006' THEN '3' WHEN '414152003' THEN '3' WHEN '445343003' THEN '3' WHEN '45465003' THEN '3' WHEN '518701000000103' THEN '3' WHEN '518721000000107' THEN '3' WHEN '519681000000108' THEN '3' WHEN '53460002' THEN '3' WHEN '56056003' THEN '3' WHEN '64693008' THEN '3' WHEN '668681000000107' THEN '3' WHEN '68486007' THEN '3' WHEN '710011000000101' THEN '3' WHEN '718021000000105' THEN '3' WHEN '718958002' THEN '3' WHEN '718959005' THEN '3' WHEN '718960000' THEN '3' WHEN '718961001' THEN '3' WHEN '718962008' THEN '3' WHEN '718963003' THEN '3' WHEN '718964009' THEN '3' WHEN '72809004' THEN '3' WHEN '733078003' THEN '3' WHEN '733446001' THEN '3' WHEN '735001008' THEN '3' WHEN '76574004' THEN '3' WHEN '7695005' THEN '3' WHEN '80208004' THEN '3' WHEN '81403004' THEN '3' WHEN '85163001' THEN '3' WHEN '88911000000101' THEN '3' WHEN '88921000000107' THEN '3' WHEN '88931000000109' THEN '3' WHEN '88941000000100' THEN '3' WHEN '88951000000102' THEN '3' WHEN '88961000000104' THEN '3' WHEN '88971000000106' THEN '3' WHEN '88981000000108' THEN '3' WHEN '92411000000108' THEN '3' WHEN '92791000000109' THEN '3' WHEN '93921000000101' THEN '3' WHEN '93931000000104' THEN '3' WHEN '93941000000108' THEN '3' WHEN '93951000000106' THEN '3' WHEN '93961000000109' THEN '3' WHEN '93981000000100' THEN '3' WHEN '93991000000103' THEN '3' WHEN '94001000000108' THEN '3' WHEN '94011000000105' THEN '3' WHEN '94021000000104' THEN '3' WHEN '94031000000102' THEN '3' WHEN '94041000000106' THEN '3' WHEN '94051000000109' THEN '3' WHEN '9533000' THEN '3' WHEN '976671000000104' THEN '3' WHEN '976691000000100' THEN '3' WHEN '977351000000100' THEN '3' WHEN '977371000000109' THEN '3' WHEN '977971000000108' THEN '3' WHEN '978011000000101' THEN '3' WHEN '978031000000109' THEN '3' WHEN '978041000000100' THEN '3' WHEN '978021000000107' THEN '3' WHEN '413773004' THEN '3' WHEN '977381000000106' THEN '3' WHEN '976701000000100' THEN '3' WHEN '977981000000105' THEN '3' WHEN '976681000000102' THEN '3' WHEN '154162007' THEN '2' WHEN '154191005' THEN '2' WHEN '185986006' THEN '2' WHEN '186014006' THEN '2' WHEN '315237009' THEN '2' WHEN '494161000000100' THEN '2' WHEN '92401000000106' THEN '2' WHEN '976651000000108' THEN '2' WHEN '977951000000104' THEN '2' WHEN '976661000000106' THEN '2' WHEN '494171000000107' THEN '2' WHEN '494181000000109' THEN '2' WHEN '977961000000101' THEN '2' WHEN '110761000000106' THEN '1' WHEN '14999008' THEN '1' WHEN '154160004' THEN '1' WHEN '154161000' THEN '1' WHEN '185985005' THEN '1' WHEN '25804004' THEN '1' WHEN '315236000' THEN '1' WHEN '401213008' THEN '1' WHEN '401214002' THEN '1' WHEN '41121000000107' THEN '1' WHEN '43481000000100' THEN '1' WHEN '44881000000100' THEN '1' WHEN '44891000000103' THEN '1' WHEN '494131000000105' THEN '1' WHEN '77711000000105' THEN '1' WHEN '82121000000108' THEN '1' WHEN '92391000000108' THEN '1' WHEN '92541000000108' THEN '1' WHEN '92551000000106' THEN '1' WHEN '92561000000109' THEN '1' WHEN '92571000000102' THEN '1' WHEN '976631000000101' THEN '1' WHEN '977911000000103' THEN '1' WHEN '977931000000106' THEN '1' WHEN '977921000000109' THEN '1' WHEN '494151000000103' THEN '1' WHEN '976641000000105' THEN '1' WHEN '977361000000102' THEN '1' WHEN '977941000000102' THEN '1' WHEN '494141000000101' THEN '1' END WHEN '1' THEN 'White British' WHEN '2' THEN 'White Irish' WHEN '3' THEN 'Other White' WHEN '4' THEN 'White and Caribbean' WHEN '5' THEN 'White and African' WHEN '6' THEN 'White and Asian' WHEN '7' THEN 'Other Mixed' WHEN '8' THEN 'Indian' WHEN '9' THEN 'Pakistani' WHEN '10' THEN 'Bangladeshi' WHEN '11' THEN 'Other South Asian' WHEN '12' THEN 'Caribbean' WHEN '13' THEN 'African' WHEN '14' THEN 'Other Black' WHEN '15' THEN 'Chinese' WHEN '16' THEN 'All other ethnic groups' END, 'Missing') AS ethnicity, CASE WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_9.patient_id IS NOT NULL) THEN true WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_9.patient_id IS NULL) THEN false END AS uti_numerator, CASE WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_10.patient_id IS NOT NULL) THEN true WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_10.patient_id IS NULL) THEN false END AS sinusitis_numerator, CASE WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_11.patient_id IS NOT NULL) THEN true WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_11.patient_id IS NULL) THEN false END AS insectbite_numerator, CASE WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_12.patient_id IS NOT NULL) THEN true WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_12.patient_id IS NULL) THEN false END AS otitismedia_numerator, CASE WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_13.patient_id IS NOT NULL) THEN true WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_13.patient_id IS NULL) THEN false END AS sorethroat_numerator, CASE WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_14.patient_id IS NOT NULL) THEN true WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_14.patient_id IS NULL) THEN false END AS shingles_numerator, CASE WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_15.patient_id IS NOT NULL) THEN true WHEN (ehrql_20261014_1919_8ccb7b1a54cc_tmp_15.patient_id IS NULL) THEN false END AS impetigo_numerator 
FROM ehrql_20261014_1919_8ccb7b1a54cc_tmp_3 LEFT OUTER JOIN ehrql_20261014_1919_8ccb7b1a54cc_tmp_4 ON ehrql_20261014_1919_8ccb7b1a54cc_tmp_4.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id LEFT OUTER JOIN (
        SELECT
            patient_id AS patient_id,
            CAST(date_of_birth AS date) AS date_of_birth,
            CASE
                WHEN sex = 'M' THEN 'male'
                WHEN sex = 'F' THEN 'female'
                WHEN sex = 'I' THEN 'intersex'
                ELSE 'unknown'
            END AS sex,
            CAST(date_of_death AS date) AS date_of_death
        FROM patient
        ) AS patients ON patients.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id LEFT OUTER JOIN ehrql_20261014_1919_8ccb7b1a54cc_tmp_5 ON ehrql_20261014_1919_8ccb7b1a54cc_tmp_5.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id LEFT OUTER JOIN ehrql_20261014_1919_8ccb7b1a54cc_tmp_7 ON ehrql_20261014_1919_8ccb7b1a54cc_tmp_7.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id LEFT OUTER JOIN ehrql_20261014_1919_8ccb7b1a54cc_tmp_9 ON ehrql_20261014_1919_8ccb7b1a54cc_tmp_9.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id LEFT OUTER JOIN ehrql_20261014_1919_8ccb7b1a54cc_tmp_10 ON ehrql_20261014_1919_8ccb7b1a54cc_tmp_10.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id LEFT OUTER JOIN ehrql_20261014_1919_8ccb7b1a54cc_tmp_11 ON ehrql_20261014_1919_8ccb7b1a54cc_tmp_11.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id LEFT OUTER JOIN ehrql_20261014_1919_8ccb7b1a54cc_tmp_12 ON ehrql_20261014_1919_8ccb7b1a54cc_tmp_12.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id LEFT OUTER JOIN ehrql_20261014_1919_8ccb7b1a54cc_tmp_13 ON ehrql_20261014_1919_8ccb7b1a54cc_tmp_13.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id LEFT OUTER JOIN ehrql_20261014_1919_8ccb7b1a54cc_tmp_14 ON ehrql_20261014_1919_8ccb7b1a54cc_tmp_14.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id LEFT OUTER JOIN ehrql_20261014_1919_8ccb7b1a54cc_tmp_15 ON ehrql_20261014_1919_8ccb7b1a54cc_tmp_15.patient_id = ehrql_20261014_1919_8ccb7b1a54cc_tmp_3.patient_id;

-- Run query 022 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_4;

-- Run query 023 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_5;

-- Run query 024 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_7;

-- Run query 025 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_9;

-- Run query 026 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_10;

-- Run query 027 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_11;

-- Run query 028 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_12;

-- Run query 029 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_13;

-- Run query 030 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_14;

-- Run query 031 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_15;

-- Run query 032 / 032
DROP TABLE IF EXISTS ehrql_20261014_1919_8ccb7b1a54cc_tmp_3;

