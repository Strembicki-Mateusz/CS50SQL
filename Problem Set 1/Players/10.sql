SELECT birth_state, COUNT(id) AS "Player_Count" FROM players
WHERE first_name LIKE "A_" AND bats IS "R"
GROUP BY birth_state
ORDER BY last_name DESC;
