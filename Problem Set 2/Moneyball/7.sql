SELECT first_name,last_name FROM players
WHERE id IN (
    SELECT player_id FROM salaries
    ORDER BY salary DESC
    LIMIT 1
);
