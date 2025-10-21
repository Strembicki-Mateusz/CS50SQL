SELECT to_user_id AS best_friend_id, COUNT(from_user_id) AS count_messages FROM messages
WHERE from_user_id IN (
    SELECT id FROM users
    WHERE username = "creativewisdom377"
)
GROUP BY to_user_id
ORDER BY count_messages DESC
LIMIT 3;
