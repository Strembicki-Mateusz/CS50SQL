SELECT year,salary FROM salaries
WHERE player_id IN (
    SELECT id FROM players
    WHERE first_name LIKE "%Cal%" AND last_name LIKE "%Ripken%"
)
ORDER BY year DESC;
