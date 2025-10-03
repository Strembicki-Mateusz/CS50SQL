SELECT city, COUNT(type) FROM schools
WHERE type LIKE "%Public%"
GROUP BY city
ORDER BY COUNT(type) DESC, city
LIMIT 10;
