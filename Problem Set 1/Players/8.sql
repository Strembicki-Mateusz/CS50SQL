SELECT ROUND(AVG(height),2) AS “Average_Height”, ROUND(AVG(weight),2) AS “Average_Weight” FROM players
WHERE final_game > 1999-12-31 AND height IS NOT NULL AND weight IS NOT NULL;
