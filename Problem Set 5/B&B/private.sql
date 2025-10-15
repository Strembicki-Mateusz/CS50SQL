CREATE VIEW message AS
WITH triplets(id, start, len, ord) AS (
  VALUES
    (14, 98, 4, 1),
    (114, 3, 5, 2),
    (618, 72, 9, 3),
    (630, 7, 3, 4),
    (932, 12, 5, 5),
    (2230, 50, 7, 6),
    (2346, 44, 10, 7),
    (3041, 14, 5, 8)
)
SELECT substr(sentences.sentence, triplets.start, triplets.len) AS phrase FROM triplets
JOIN sentences ON sentences.id = triplets.id
ORDER BY triplets.ord;
