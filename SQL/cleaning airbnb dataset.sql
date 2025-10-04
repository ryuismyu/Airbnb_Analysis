-- First step is to create the database and the full master data table to get ready for csv import--
CREATE DATABASE airbnb;
CREATE TABLE airbnb_data (
id varchar(1000),
NAME varchar(10000),
host_id varchar(100),
host_identity_verified varchar(100),
host_name varchar(100),
neighbourhood_group varchar(100),
neighbourhood varchar(100),
lat varchar(100),
longitude varchar(100),
country varchar(100),
country_code varchar(100),
instant_bookable varchar(100),
cancellation_policy varchar(100),
room_type varchar(100),
Construction_year varchar(100),
price varchar(100),
service_fee varchar(100),
minimum_nights varchar(100),
number_of_reviews varchar(100),
last_review varchar(100),
reviews_per_month varchar(100),
review_rate_number varchar(100),
calculated_host_listings_count varchar(100),
availability_365 varchar(100),
house_rules LONGTEXT,
license varchar(100)
);
-- query for importing the full csv file--
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Airbnb_Open_Data.csv'
INTO TABLE airbnb_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
-- To check if the import was successful
SELECT * FROM airbnb_data;

-- Now I need to create four tables:
-- a listings table: columns related to characteristics of the property
-- A reviews table: with columns related to how the property was reviewed
-- a host table: with characteristics abougt the host

-- QUERY FOR CREATING LISTING TABLE--
CREATE TABLE listings AS
SELECT
    id AS listing_id,
    name,
    host_id,
    host_name,
    neighbourhood_group,
    neighbourhood,
    room_type,
    construction_year,
    price,
    minimum_nights,
    availability_365,
    calculated_host_listings_count
FROM airbnb_data;
-- query for creating reviews table--
CREATE TABLE reviews AS
SELECT
    id AS listing_id,
    number_of_reviews,
    last_review,
    reviews_per_month,
    review_rate_number
FROM airbnb_data;
-- hosts table--
CREATE TABLE hosts AS
SELECT DISTINCT
    host_id,
    host_name,
    host_identity_verified
FROM airbnb_data;
-- getting rid of dollar sign in price column so it can be recognized as int--

UPDATE listings 
SET price =REPLACE(price, "$", "");
UPDATE listings
SET price = '0'
WHERE price = '' OR price IS NULL;
UPDATE listings
SET price = REPLACE(REPLACE(TRIM(price), '$', ''), ',', '');
ALTER TABLE listings modify price INT;
-- fixing the error--


CREATE TABLE hosts_clean AS
SELECT DISTINCT host_id, host_name, host_identity_verified
FROM hosts;
-- setting this column values to default to unconfirmed if no value or if null--
UPDATE hosts_clean
SET host_identity_verified = 'unconfirmed'
WHERE host_identity_verified = '' or host_identity_verified IS NULL;

ALTER TABLE hosts_clean MODIFY host_identity_verified ENUM('verified','unconfirmed') DEFAULT 'unconfirmed';

ALTER TABLE hosts_clean MODIFY host_id BIGINT ;


CREATE TABLE hosts (
    host_id BIGINT PRIMARY KEY,
    host_name VARCHAR(255),
    host_identity_verified ENUM('verified','unconfirmed') DEFAULT 'unconfirmed'
);
INSERT INTO hosts (host_id, host_name, host_identity_verified)
SELECT host_id,
       MAX(host_name) AS host_name,
       CASE 
           WHEN MAX(host_identity_verified) IN ('verified','unconfirmed') THEN MAX(host_identity_verified)
           ELSE 'unconfirmed'
       END AS host_identity_verified
FROM hosts_clean
GROUP BY host_id;
-- hosts data is cleaned with the above code--

SELECT * FROM listings;
UPDATE listings
SET minimum_nights = 0
WHERE minimum_nights = '' OR minimum_nights IS NULL;

UPDATE listings
SET price = 0
WHERE price = '' OR price IS NULL;

UPDATE listings
SET availability_365 = 0
WHERE availability_365 = '' OR availability_365 IS NULL;

UPDATE listings
SET calculated_host_listings_count = 0
WHERE calculated_host_listings_count = '' OR calculated_host_listings_count IS NULL;

ALTER TABLE listings
MODIFY price INT,
MODIFY minimum_nights INT,
MODIFY availability_365 INT,
MODIFY calculated_host_listings_count INT;
SELECT * FROM listings;

SELECT COUNT(*) FROM listings; -- this query shows the total amount of rows--

USE airbnb;
SELECT * FROM hosts;
SELECT * FROM listings;

Select COUNT(DISTINCT listing_id)
FROM listings;
SELECT * FROM listings;
-- cleaning the data for listings--
UPDATE listings
SET construction_year = NULL
WHERE construction_year = '' OR construction_year IS NULL;

ALTER TABLE listings
    MODIFY listing_id BIGINT primary key,
    MODIFY name VARCHAR(255),
    MODIFY host_id BIGINT,
    MODIFY host_name VARCHAR(255),
    MODIFY neighbourhood_group VARCHAR(100),
    MODIFY neighbourhood VARCHAR(255),
    MODIFY room_type ENUM('Entire home/apt','Private room','Shared room','Hotel room'),
    MODIFY construction_year YEAR,
    MODIFY price INT UNSIGNED,
    MODIFY minimum_nights INT,
    MODIFY availability_365 INT,
    MODIFY calculated_host_listings_count SMALLINT UNSIGNED;
    UPDATE reviews
SET last_review = STR_TO_DATE(last_review, '%m/%d/%Y')
WHERE last_review IS NOT NULL AND last_review != '';
    -- Convert empty strings to null-
    UPDATE reviews
    SET last_review = NULL
    WHERE last_review = '';
    -- Change column type to date, accepting null values--
    ALTER TABLE reviews
    MODIFY last_review DATE NULL;
    
    -- Clean number of reviews by converting blanks to 0
UPDATE reviews
SET number_of_reviews = 0
WHERE number_of_reviews = '' OR number_of_reviews IS NULL;

-- Change column type to int unsigned
ALTER TABLE reviews
MODIFY number_of_reviews INT UNSIGNED NOT NULL DEFAULT 0;
-- 4️⃣ Clean reviews_per_month
-- Convert blanks or invalid to 0
UPDATE reviews
SET reviews_per_month = 0
WHERE reviews_per_month = '' OR reviews_per_month IS NULL;

-- Change column type to FLOAT (can be decimal)
ALTER TABLE reviews
MODIFY reviews_per_month FLOAT UNSIGNED NOT NULL DEFAULT 0;

-- 5️⃣ Clean review_rate_number (if exists)
-- Convert blanks or NULL to 0
UPDATE reviews
SET review_rate_number = 0
WHERE review_rate_number = '' OR review_rate_number IS NULL;

-- Change column type to FLOAT UNSIGNED
ALTER TABLE reviews
MODIFY review_rate_number FLOAT UNSIGNED NOT NULL DEFAULT 0;

