-- Get a list of the most visited cities.

-- Select the name of the city and the number of reservations for that city.
-- Order the results from highest number of reservations to lowest number of reservations.

SELECT p.city, COUNT(r) AS total_reservations
FROM properties p
JOIN property_reviews prs ON p.id = prs.property_id
JOIN reservations r ON prs.reservation_id = r.id
GROUP BY p.city
ORDER BY total_reservations DESC;