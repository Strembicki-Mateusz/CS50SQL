SELECT salary FROM salaries
WHERE year = "2001" AND player_id IN (
    SELECT player_id FROM performances
    ORDER BY HR DESC
    LIMIT 1
);
