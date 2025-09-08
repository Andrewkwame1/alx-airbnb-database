-- Retrieve all bookings and their respective users (Postgres / MySQL)
SELECT 
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at
FROM "Booking" b
INNER JOIN "User" u
    ON b.user_id = u.user_id
ORDER BY b.created_at DESC;


-- Retrieve all properties and their reviews (includes properties with no reviews)
SELECT
    p.property_id,
    p.host_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created_at,
    r.review_id,
    r.user_id AS reviewer_id,
    r.rating,
    r.comment,
    r.created_at AS review_created_at
FROM "Property" p
LEFT JOIN "Review" r
    ON p.property_id = r.property_id
ORDER BY p.created_at DESC;


-- Retrieve all users and all bookings.
-- Postgres: use FULL OUTER JOIN
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at AS user_created_at,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at
FROM "User" u
FULL OUTER JOIN "Booking" b
    ON u.user_id = b.user_id
ORDER BY user_created_at NULLS LAST, booking_created_at NULLS LAST;

-- MySQL compatibility: emulate FULL OUTER JOIN via UNION of LEFT and RIGHT joins
-- (uncomment and use if running on MySQL)
-- SELECT
--     u.user_id, u.first_name, u.last_name, u.email, u.phone_number, u.role, u.created_at AS user_created_at,
--     b.booking_id, b.property_id, b.start_date, b.end_date, b.total_price, b.status, b.created_at AS booking_created_at
-- FROM `User` u
-- LEFT JOIN `Booking` b ON u.user_id = b.user_id
-- UNION
-- SELECT
--     u.user_id, u.first_name, u.last_name, u.email, u.phone_number, u.role, u.created_at AS user_created_at,
--     b.booking_id, b.property_id, b.start_date, b.end_date, b.total_price, b.status, b.created_at AS booking_created_at
-- FROM `User` u
-- RIGHT JOIN `Booking` b ON u.user_id = b.user_id
-- ORDER BY user_created_at IS NULL, user_created_at, booking_created_at IS NULL, booking_created_at;