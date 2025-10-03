SELECT schools.name, expenditures.per_pupil_expenditure, graduation_rates.graduated FROM districts
JOIN schools ON schools.district_id = districts.id
JOIN expenditures ON expenditures.district_id = districts.id
JOIN graduation_rates ON graduation_rates.school_id = schools.id
ORDER BY expenditures.per_pupil_expenditure DESC, schools.name ASC;
