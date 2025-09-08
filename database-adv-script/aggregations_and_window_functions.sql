----Write a query to find the total number of bookings made by each user, using the COUNT function and GROUP BY clause.
SELECT
  u.user_id,
  u.first_name,
  u.last_name,
  COUNT(b.booking_id) AS total_bookings
FROM "User" u
LEFT JOIN "Booking" b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name;

-- Rank properties by total bookings (compute totals in derived table then rank)
SELECT
  p.property_id,
  p.name,
  COALESCE(s.total_bookings, 0) AS total_bookings,
  RANK() OVER (ORDER BY COALESCE(s.total_bookings, 0) DESC) AS booking_rank
FROM "Property" p
LEFT JOIN (
  SELECT property_id, COUNT(*) AS total_bookings
  FROM "Booking"
  GROUP BY property_id
) s ON s.property_id = p.property_id
ORDER BY booking_rank;