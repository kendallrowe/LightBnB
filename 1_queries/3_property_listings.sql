-- Show all details about properties including their average rating.

-- Select all columns from the properties table, and the average rating for each property.
-- Order the results from lowest cost_per_night to highest cost_per_night.
-- Limit the number of results to 10.
-- Only show listings that have a rating >= 4 stars.
-- To build this incrementally, you can start by getting all properties without the average rating first.

SELECT p.*, AVG(prs.rating) AS average_rating
FROM properties p
JOIN property_reviews prs ON p.id = prs.property_id
WHERE city LIKE '%ancouv%'
GROUP BY p.id
HAVING AVG(prs.rating) >= 4
ORDER BY p.cost_per_night
LIMIT 10;