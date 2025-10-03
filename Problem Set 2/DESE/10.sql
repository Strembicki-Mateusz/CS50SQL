SELECT districts.name, expenditures.per_pupil_expenditure FROM districts
JOIN expenditures ON expenditures.district_id = districts.id
WHERE districts.type LIKE "%Public%"
ORDER BY expenditures.per_pupil_expenditure DESC
LIMIT 10;
