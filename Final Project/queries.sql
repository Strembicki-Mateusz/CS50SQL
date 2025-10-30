-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- ==========================================
-- Query 1: Top 10 most active artists
-- ==========================================
-- Returns the artists whose songs appear most often in TikToks.
-- Only non-deleted TikToks are included.
SELECT
    artists.name AS artist,
    COUNT(tiktoks.tiktok_id) AS total_tiktoks
FROM tiktoks
JOIN songs ON songs.song_id = tiktoks.song_id
JOIN artists ON artists.artist_id = songs.artist_id
WHERE tiktoks.deleted = 0
GROUP BY artists.name
ORDER BY total_tiktoks DESC
LIMIT 10;


-- ==========================================
-- Query 2: Most popular dance styles
-- ==========================================
-- Returns the number of TikToks created for each dance style.
-- Helps identify which styles are the most used overall.
SELECT
    styles.style_name,
    COUNT(tiktoks.tiktok_id) AS total_videos
FROM tiktoks
JOIN styles ON tiktoks.style_id = styles.style_id
WHERE tiktoks.deleted = 0
GROUP BY styles.style_name
ORDER BY total_videos DESC;


-- ==========================================
-- Query 3: Artists creating Pop songs used in Hip-Hop dances
-- ==========================================
-- Returns artists whose Pop songs are used in Hip-Hop style TikToks.
SELECT
    artists.name AS artist,
    songs.genre AS genre,
    styles.style_name AS style
FROM tiktoks
JOIN songs ON songs.song_id = tiktoks.song_id
JOIN artists ON artists.artist_id = songs.artist_id
JOIN styles ON styles.style_id = tiktoks.style_id
WHERE songs.genre = 'Pop' AND styles.style_name = 'Hip-Hop'
GROUP BY artist, genre, style;


-- ==========================================
-- Query 4: Dance style popularity by age group
-- ==========================================
-- Groups users into age categories and shows which dance styles
-- are most popular among each group.
SELECT
    CASE
        WHEN users.age BETWEEN 16 AND 20 THEN '16-20'
        WHEN users.age BETWEEN 21 AND 30 THEN '21-30'
        WHEN users.age BETWEEN 31 AND 40 THEN '31-40'
        ELSE '40+'
    END AS age_group,
    styles.style_name,
    COUNT(tiktoks.tiktok_id) AS total
FROM tiktoks
JOIN users ON users.user_id = tiktoks.user_id
JOIN styles ON styles.style_id = tiktoks.style_id
WHERE tiktoks.deleted = 0
GROUP BY age_group, styles.style_name
ORDER BY age_group, total DESC;


-- ==========================================
-- Query 5: Music genre popularity by age group
-- ==========================================
-- Similar to the previous query, but analyzes which music genres
-- are most popular among users of different age groups.
SELECT
    CASE
        WHEN users.age BETWEEN 16 AND 20 THEN '16-20'
        WHEN users.age BETWEEN 21 AND 30 THEN '21-30'
        WHEN users.age BETWEEN 31 AND 40 THEN '31-40'
        ELSE '40+'
    END AS age_group,
    songs.genre,
    COUNT(tiktoks.tiktok_id) AS total
FROM tiktoks
JOIN users ON users.user_id = tiktoks.user_id
JOIN songs ON songs.song_id = tiktoks.song_id
WHERE tiktoks.deleted = 0
GROUP BY age_group, songs.genre
ORDER BY age_group, total DESC;


-- ==========================================
-- Query 6: Most common song–style combinations
-- ==========================================
-- Shows which music genre and dance style combinations
-- appear most frequently together in TikToks.
SELECT
    songs.genre,
    styles.style_name,
    COUNT(tiktoks.tiktok_id) AS combo_count
FROM tiktoks
JOIN songs ON songs.song_id = tiktoks.song_id
JOIN styles ON styles.style_id = tiktoks.style_id
WHERE tiktoks.deleted = 0
GROUP BY songs.genre, styles.style_name
ORDER BY combo_count DESC;


-- ==========================================
-- Query 7: Rating change history
-- ==========================================
-- Displays logs of TikTok rating changes for transparency.
-- Assumes a 'tiktok_logs' table records rating updates.
SELECT
    tiktoks.tiktok_id,
    users.username,
    tiktok_logs.old_rating,
    tiktok_logs.new_rating,
    tiktok_logs.change_date
FROM tiktok_logs
JOIN tiktoks ON tiktok_logs.tiktok_id = tiktoks.tiktok_id
JOIN users ON users.user_id = tiktoks.user_id
ORDER BY change_date DESC;


-- ==========================================
-- Query 8: Most active user for each dance style
-- ==========================================
-- Uses a correlated subquery to find the user who uploaded
-- the highest number of TikToks for each specific dance style.
-- The subquery compares each user’s TikTok count to the maximum count per style.
SELECT
    styles.style_name,
    users.username,
    COUNT(tiktoks.tiktok_id) AS total_tiktoks
FROM tiktoks
JOIN users ON users.user_id = tiktoks.user_id
JOIN styles ON styles.style_id = tiktoks.style_id
WHERE tiktoks.deleted = 0
GROUP BY styles.style_name, users.username
HAVING COUNT(tiktoks.tiktok_id) = (
    SELECT MAX(style_count)
    FROM (
        SELECT COUNT(tiktoks.tiktok_id) AS style_count
        FROM tiktoks
        WHERE tiktoks.style_id = styles.style_id AND tiktoks.deleted = 0
        GROUP BY tiktoks.user_id
    )
);
