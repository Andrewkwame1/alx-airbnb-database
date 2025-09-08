-- database-adv-script/perfomance.sql
-- Initial Query: Retrieve all bookings with user, property, and payment details

SELECT
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    pay.payment_id,
    pay.amount,
    pay.payment_date,
    pay.payment_method
FROM "Booking" b
JOIN "User" u ON b.user_id = u.user_id
JOIN "Property" p ON b.property_id = p.property_id
LEFT JOIN "Payment" pay ON pay.booking_id = b.booking_id
ORDER BY b.created_at DESC;

-- Refactored: aggregate payments, narrow columns, and constrain by date range for partition pruning

SELECT
  b.booking_id,
  b.start_date,
  b.end_date,
  b.total_price,
  b.status        AS booking_status,
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  p.property_id,
  p.name          AS property_name,
  p.location,
  p.pricepernight,
  pay.total_amount,
  pay.last_payment_date,
  pay.payment_method
FROM "Booking" b
JOIN "User" u      ON b.user_id = u.user_id
JOIN "Property" p  ON b.property_id = p.property_id
LEFT JOIN (
  SELECT
    booking_id,
    SUM(amount)           AS total_amount,
    MAX(payment_date)     AS last_payment_date,
    MAX(payment_method)   AS payment_method
  FROM "Payment"
  GROUP BY booking_id
) pay ON pay.booking_id = b.booking_id
WHERE b.start_date BETWEEN DATE '2025-01-01' AND DATE '2025-01-31'
ORDER BY b.start_date, b.booking_id;

ANALYZE;

EXPLAIN (ANALYZE, BUFFERS) 
SELECT 
  b.booking_id,
  b.start_date,
  b.end_date,
  b.total_price,
  b.status        AS booking_status,
  u.user_id,
  u.first_name,
  u.last_name,
  u.email,
  p.property_id,
  p.name          AS property_name,
  p.location,
  p.pricepernight,
  pay.total_amount,
  pay.last_payment_date,
  pay.payment_method;

BEGIN;
-- ensure types match; migrate rows (watch partition key ranges)
INSERT INTO "Booking"(booking_id, user_id, property_id, start_date, end_date, total_price, status, created_at)
SELECT booking_id, user_id, property_id, start_date, end_date, total_price, status, created_at
FROM "Booking_backup";
ANALYZE;
COMMIT;