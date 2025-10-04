-- Finding the average price per room type--
SELECT room_type, round(avg(price),2) AS avg_price, COUNT(*) as number_of_listings
FROM listings
GROUP BY room_type
ORDER BY avg_price DESC;

-- Identifying the top hosts--
SELECT h.host_name, COUNT(l.listing_id) AS total_listings
FROM hosts_clean h
JOIN listings l ON h.host_id = l.host_id
GROUP BY h.host_name
ORDER BY total_listings DESC
limit 20;

-- finding average price by neighbourhood group--
SELECT neighbourhood_group, ROUND(AVG(price),2) AS avg_price
FROM listings
GROUP BY neighbourhood_group
ORDER BY avg_price DESC;

-- Find the top 20 listings with the highest review rate
SELECT l.name, r.number_of_reviews, r.reviews_per_month
FROM listings l
JOIN reviews r
ON l.listing_id = r.listing_id
ORDER BY r.number_of_reviews DESC
LIMIT 20;

-- finding all listings that are availible the whole year (there are 2484 listings)
SELECT listing_id, name, neighbourhood,availability_365
FROM listings
WHERE availability_365 = 365;
-- finding the least availabile listings ( there are 23896 listings)
SELECT listing_id, name, neighbourhood, availability_365
FROM listings
WHERE availability_365=0;

-- Finding total revenue by neighbourhood group and number of listings in neighbourhood group
SELECT neighbourhood_group, COUNT(listing_id) AS 'number of listings',
       SUM(price * availability_365) AS total_revenue
FROM listings
GROUP BY neighbourhood_group
ORDER BY total_revenue DESC;

SELECT room_type, 
ROUND(AVG(price),2) AS avg_price,
ROUND(AVG(number_of_reviews),2) as avg_reviews
FROM listings l	
join reviews r on l.listing_id = r.listing_id
GROUP BY room_type
ORDER BY avg_reviews DESC;


