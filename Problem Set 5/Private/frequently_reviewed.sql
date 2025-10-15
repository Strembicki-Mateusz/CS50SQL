CREATE VIEW "frequently_reviewed" AS
SELECT listings.id, listings.property_type, listings.host_name, COUNT(reviews.listing_id) as reviews FROM reviews
JOIN listings ON listings.id = reviews.listing_id
GROUP BY listings.id
ORDER BY reviews DESC
LIMIT 100;
