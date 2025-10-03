SELECT districts.name,
       expenditures.per_pupil_expenditure,
       staff_evaluations.exemplary
FROM districts
JOIN expenditures ON districts.id = expenditures.district_id
JOIN staff_evaluations ON districts.id = staff_evaluations.district_id
WHERE districts.type LIKE "%Public%"
  AND expenditures.per_pupil_expenditure > (
      SELECT ROUND(AVG(per_pupil_expenditure),2) FROM expenditures
  )
  AND staff_evaluations.exemplary > (
      SELECT MAX(exemplary)/2 FROM staff_evaluations
  )
ORDER BY staff_evaluations.exemplary DESC, expenditures.per_pupil_expenditure DESC;
