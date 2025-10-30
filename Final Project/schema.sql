-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

----------------------
--      TABLES      --
----------------------

-- Table which contain iformation about tiktok. In this case it is song, dance style, who upload it and rating of this tiktok. I also use soft delete when a user deleted tiktok
CREATE TABLE "tiktoks" (
    "tiktok_id" INTEGER,
    "song_id" INTEGER,
    "user_id" INTEGER,
    "style_id" INTEGER,
    "rating" INTEGER,
    "upload_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted" INTEGER,
    PRIMARY KEY("tiktok_id"),
    FOREIGN KEY("song_id") REFERENCES "songs"("song_id") ON DELETE CASCADE,
    FOREIGN KEY("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE,
    FOREIGN KEY("style_id") REFERENCES "styles"("style_id")
);

-- Table which contain title and genre of song but the artist_id also to identify his/her name. There is also bpm which can be used to predict style of dance
CREATE TABLE "songs" (
    "song_id" INTEGER,
    "artist_id" INTEGER,
    "title" TEXT NOT NULL,
    "genre" TEXT NOT NULL,
    "bpm" INTEGER,
    PRIMARY KEY("song_id"),
    FOREIGN KEY("artist_id") REFERENCES "artists"("artist_id") ON DELETE CASCADE
);

-- Table which contain basic knowledge about accounts. You must upload your age to using aplication (age > 16)
CREATE TABLE "users" (
    "user_id" INTEGER,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    "age" INTEGER CHECK("age" >= 16),
    PRIMARY KEY("user_id")
);

-- Table with basic knowledge about artist (name and age)
CREATE TABLE "artists" (
    "artist_id" INTEGER,
    "name" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    PRIMARY KEY("artist_id")
);

-- Table with some knowhow about dance style (name and origin)
CREATE TABLE "styles" (
    "style_id" INTEGER,
    "style_name" TEXT NOT NULL,
    "origin_country" TEXT NOT NULL,
    PRIMARY KEY("style_id")
);

-- Table which containt history of raiting changes
CREATE TABLE "tiktok_logs" (
    "log_id" INTEGER,
    "tiktok_id" INTEGER NOT NULL,
    "old_rating" INTEGER NOT NULL,
    "new_rating" INTEGER NOT NULL,
    "change_date" NUMERIC DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("log_id"),
    FOREIGN KEY("tiktok_id") REFERENCES "tiktoks"("tiktok_id")
);


---------------------
--      VIEWS      --
---------------------

-- Shows the latest TikTok videos (undeleted), along with the username, song title, artist, and rating.
CREATE VIEW "latest_tiktoks" AS
SELECT
    users.username AS user,
    songs.title AS song,
    artists.name AS artist,
    tiktoks.rating,
    tiktoks.upload_date
FROM tiktoks
JOIN users ON users.user_id = tiktoks.user_id
JOIN songs ON songs.song_id = tiktoks.song_id
JOIN artists ON artists.artist_id = songs.artist_id
WHERE tiktoks.deleted = 0
ORDER BY tiktoks.upload_date DESC;


-- It shows which artist most often creates which genre of music and which dance style it is most often associated with.
CREATE VIEW "dance_style" AS
SELECT
    artists.name AS artist,
    songs.genre AS genre,
    styles.style_name AS dance_style,
    COUNT(tiktoks.tiktok_id) AS total_tiktoks
FROM tiktoks
JOIN songs ON songs.song_id = tiktoks.song_id
JOIN artists ON artists.artist_id = songs.artist_id
JOIN styles ON styles.style_id = tiktoks.style_id
WHERE tiktoks.deleted = 0
GROUP BY artists.name, songs.genre, styles.style_name
ORDER BY total_tiktoks DESC;


CREATE VIEW "artist_top_style" AS
SELECT artist, genre, dance_style, total_tiktoks
FROM dance_style
WHERE (artist, total_tiktoks) IN (
    SELECT artist, MAX(total_tiktoks)
    FROM dance_style
    GROUP BY artist
);


-- Shows users which upload most active TikToks
CREATE VIEW "most_active_users" AS
SELECT
    users.username AS name,
    COUNT(tiktoks.tiktok_id) AS total_tiktoks
FROM users
LEFT JOIN tiktoks ON users.user_id = tiktoks.user_id
WHERE tiktoks.deleted = 0
GROUP BY users.username
ORDER BY total_tiktoks DESC;


-- Shows which styles are trending
CREATE VIEW "trending_styles" AS
SELECT
    styles.style_name,
    COUNT(tiktoks.tiktok_id) AS last_week_videos
FROM tiktoks
JOIN styles ON styles.style_id = tiktoks.style_id
WHERE DATE(tiktoks.upload_date) >= DATE('now', '-7 days')
GROUP BY styles.style_name
ORDER BY last_week_videos DESC;


-- Shows average rating for each dance style
CREATE VIEW "top_rated_styles" AS
SELECT
    styles.style_name,
    ROUND(AVG(tiktoks.rating), 2) AS avg_rating,
    COUNT(tiktoks.tiktok_id) AS total_tiktoks
FROM tiktoks
JOIN styles ON tiktoks.style_id = styles.style_id
WHERE tiktoks.deleted = 0 AND tiktoks.rating IS NOT NULL
GROUP BY styles.style_name
ORDER BY avg_rating DESC;



------------------------
--      TRIGGERS      --
------------------------

-- Save rating change
CREATE TRIGGER log_rating_change
AFTER UPDATE OF rating ON tiktoks
FOR EACH ROW
WHEN OLD.rating IS NOT NEW.rating
BEGIN
    INSERT INTO tiktok_logs (tiktok_id, old_rating, new_rating)
    VALUES (OLD.tiktok_id, OLD.rating, NEW.rating);
END;



-- After deleting artist delete his/her songs also.
CREATE TRIGGER cleanup_orphan_songs
AFTER DELETE ON artists
FOR EACH ROW
BEGIN
    DELETE FROM songs
    WHERE artist_id = OLD.artist_id
    AND song_id NOT IN (SELECT song_id FROM tiktoks);
END;



-- Deleting tiktoks.
CREATE TRIGGER soft_delete_tiktok
BEFORE DELETE ON tiktoks
FOR EACH ROW
BEGIN
    UPDATE tiktoks
    SET deleted = 1
    WHERE tiktok_id = OLD.tiktok_id;
    SELECT RAISE(IGNORE);
END;

-----------------------
--      INDEXES      --
-----------------------

-- Speeds up queries joining TikToks with Users
CREATE INDEX "idx_tiktoks_user_id"
ON "tiktoks" ("user_id");


-- Optimizes joins between TikToks and Songs
CREATE INDEX "idx_tiktoks_song_id"
ON "tiktoks" ("song_id");


-- Improves performance for style-based queries (used in top_rated_styles, dance_style, trending_styles)
CREATE INDEX "idx_tiktoks_style_id"
ON "tiktoks" ("style_id");


-- Helps filter out deleted TikToks quickly. Many views use WHERE deleted = 0.
CREATE INDEX "idx_tiktoks_deleted"
ON "tiktoks" ("deleted");


-- Makes ORDER BY upload_date faster, especially for the latest_tiktoks and trending_styles views.
CREATE INDEX "idx_tiktoks_upload_date"
ON "tiktoks" ("upload_date");


-- Optimizes joins between Songs and Artists.
CREATE INDEX "idx_songs_artist_id"
ON "songs" ("artist_id");


-- Speeds up genre filtering (e.g., WHERE genre = 'Pop').
CREATE INDEX "idx_songs_genre"
ON "songs" ("genre");


-- Ensures fast username lookup (login and display).
CREATE INDEX "idx_users_username"
ON "users" ("username");


-- Useful when filtering or grouping by dance style.
CREATE INDEX "idx_styles_style_name"
ON "styles" ("style_name");


-- Makes joins between tiktok_logs and tiktoks faster.
CREATE INDEX "idx_tiktok_logs_tiktok_id"
ON "tiktok_logs" ("tiktok_id");


-- Useful for ordering logs by date (ORDER BY change_date DESC).
CREATE INDEX "idx_tiktok_logs_change_date"
ON "tiktok_logs" ("change_date");



-- Speeds up queries combining user activity and dance styles,
-- especially for age/style analysis and HAVING subqueries.
-- Used in:
--   - most active user per style (last query)
--   - age group vs. style popularity
CREATE INDEX "idx_tiktoks_user_style"
ON "tiktoks" ("user_id", "style_id");


-- Helps with queries grouping by user age and song genre.
-- Used in:
--   - genre popularity by age group
CREATE INDEX "idx_tiktoks_user_genre"
ON "tiktoks" ("user_id", "song_id");



-- Speeds up queries filtering by genre and analyzing tempo.
-- Useful for analytics that relate genre ↔️ dance style.
CREATE INDEX "idx_songs_genre_bpm"
ON "songs" ("genre", "bpm");


-- Speeds up average rating calculations (e.g. top_rated_styles view)
-- and potential filtering by rating in future queries.
CREATE INDEX "idx_tiktoks_rating"
ON "tiktoks" ("rating");


-- Optimizes queries that categorize users into age groups.
-- Used in:
--   - style popularity by age
--   - genre popularity by age
CREATE INDEX "idx_users_age"
ON "users" ("age");


-- Composite index for filtering on style + deletion flag.
-- Used in:
--   - almost every view and trend query (WHERE style_id AND deleted = 0)
CREATE INDEX "idx_tiktoks_style_deleted"
ON "tiktoks" ("style_id", "deleted");


-- Optimizes sorting and joining for rating history queries.
-- Combines tiktok_id and change_date for better ORDER BY performance.
CREATE INDEX "idx_tiktok_logs_rating_change"
ON "tiktok_logs" ("tiktok_id", "change_date");
