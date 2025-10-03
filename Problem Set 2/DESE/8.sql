SELECT expenditures.pupils, districts.name FROM districts
JOIN expenditures ON expenditures.district_id = districts.id
GROUP BY districts.id
ORDER BY expenditures.pupils DESC;
