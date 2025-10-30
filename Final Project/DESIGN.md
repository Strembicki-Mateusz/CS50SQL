# Design Document

By Mateusz Strembicki

Video Link - 

## Scope

### Purpose
The purpose of the *Dance Analytics* database is to analyze relationships between music, dance styles, and user engagement on a TikTok-like platform.
It allows us to discover trends such as which music genres are most popular for specific dance styles, which users are most active, and how age influences dance preferences.

### In Scope
The database includes:
- **Users** who upload TikToks and rate them.
- **Songs** with details such as title, genre, and BPM (beats per minute).
- **Artists** who create these songs.
- **Dance styles** used in TikToks.
- **TikToks** that link users, songs, and styles.
- **TikTok logs** that record rating changes over time.

### Out of Scope
The database does *not* include:
- Video file storage or metadata (length, resolution, etc.).
- Comments, likes, or social interactions other than ratings.
- Artist discographies beyond individual songs.
- Advanced user behavior analytics (e.g., session data, geolocation).

---

## Functional Requirements

### Within Scope
A user (or analyst) should be able to:
- Track which artists and genres are most popular in TikToks.
- Analyze which dance styles are trending.
- Identify the most active users.
- Compare popularity of dance styles and genres across age groups.
- Monitor rating changes for videos over time.
- View the latest TikToks and top-rated styles.

### Beyond Scope
The database does *not* allow:
- Uploading or editing videos (this is handled externally).
- Performing authentication or password management.
- Handling monetary transactions, sponsorships, or advertisements.
- Running AI-driven recommendations or predictions directly in SQL.

---

## Representation

### Entities


| Entity | Attributes | Description |
|---------|-------------|-------------|
| **Users** | `user_id`, `username`, `password`, `age` | Represents platform users who upload TikToks. Age must be ≥16. |
| **Artists** | `artist_id`, `name`, `age` | Represents musicians whose songs are used in videos. |
| **Songs** | `song_id`, `artist_id`, `title`, `genre`, `bpm` | Stores song data and links each song to an artist. |
| **Styles** | `style_id`, `style_name`, `origin_country` | Represents dance styles used in TikToks. |
| **TikToks** | `tiktok_id`, `song_id`, `user_id`, `style_id`, `rating`, `upload_date`, `deleted` | Represents uploaded videos combining user, song, and style. Uses a *soft delete* flag. |
| **TikTok Logs** | `log_id`, `tiktok_id`, `old_rating`, `new_rating`, `change_date` | Stores rating change history for each TikTok. |

### Type choices and constraints
- All IDs are `INTEGER` with `PRIMARY KEY` for simplicity and indexing.
- `CHECK(age >= 16)` ensures application rules for user age.
- `FOREIGN KEY ... ON DELETE CASCADE` maintains referential integrity and supports automatic cleanup.
- `deleted` flag implements *soft delete* instead of physical removal for auditability.

---

### Relationships

| Relationship | Type | Description |
|---------------|------|-------------|
| User → TikTok | One-to-Many | Each user can upload many TikToks. |
| Song → TikTok | One-to-Many | Each song can appear in multiple TikToks. |
| Artist → Song | One-to-Many | Each artist can have multiple songs. |
| Style → TikTok | One-to-Many | Each TikTok has one dominant dance style. |
| TikTok → TikTok Logs | One-to-Many | Each TikTok can have multiple rating changes. |

**ER Diagram (conceptual)**
## Optimizations

### Indexes
To improve performance of analytical queries and frequent joins:
- `idx_tiktoks_song`, `idx_tiktoks_user`, `idx_tiktoks_style` → Speed up joins on foreign keys.
- `idx_tiktoks_deleted` → Optimizes filtering for undeleted TikToks.
- `idx_tiktoks_upload_date` → Speeds up sorting by upload time.
- `idx_users_age` → Used in age-group analysis queries.
- `idx_tiktoks_rating` → Speeds up aggregation in rating-based views.
- `idx_tiktok_logs_rating_change` → Optimizes rating history retrieval.

### Views
Used to simplify analytics and provide virtual reports:
- `latest_tiktoks` → Recent videos with artist and song info.
- `dance_style` → Links artists, genres, and dance styles.
- `artist_top_style` → Top dance style for each artist.
- `most_active_users` → Users ranked by activity.
- `trending_styles` → Styles trending over the last week.
- `top_rated_styles` → Styles ranked by average rating.

### Triggers
Used to maintain data consistency:
- `log_rating_change` → Automatically logs rating updates.
- `cleanup_orphan_songs` → Removes unused songs after artist deletion.
- `soft_delete_tiktok` → Converts DELETE into soft delete.

---

## Limitations

- The database focuses on *analytical insight*, not real-time app interactions.
- It doesn’t store full video metadata (file paths, duration, etc.).
- No multi-language support for style or genre names.
- Limited scalability — SQLite is sufficient for prototype/academic use but not for large-scale production.
- Age groups are hardcoded and may not adapt dynamically to user demographics.

---

## Future Improvements

- Add **likes and comments** to better reflect social engagement.
- Implement **tags or hashtags** for advanced search and filtering.
- Introduce **popularity trends over time** (time-series view).
- Add **user location** for geographic analysis of dance trends.
- Support **multiple platforms** (e.g., YouTube Shorts, Instagram Reels) for broader comparison.

---

## Summary
The *Dance Analytics* database provides a well-normalized, efficient schema to study the interplay between users, songs, artists, and dance styles on a social video platform.
It’s optimized for trend analysis, user activity tracking, and creative insights into dance–music relationships.
