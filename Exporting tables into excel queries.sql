-- How to export csv files into excel--

SELECT * 
FROM listings
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/listings_clean.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * 
FROM hosts_clean
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hosts_clean.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * 
FROM reviews
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/reviews.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';