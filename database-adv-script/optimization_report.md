# Optimization Report — bookings + user + property + payment query

Summary
- File with the initial query: [database-adv-script/perfomance.sql](database-adv-script/perfomance.sql)
- Tables involved: [`Booking`](database-script-0x01/schema.sql), [`User`](database-script-0x01/schema.sql), [`Property`](database-script-0x01/schema.sql), [`Payment`](database-script-0x01/schema.sql)
- Monitoring & measurement notes: see [database-adv-script/performance_monitoring.md](database-adv-script/performance_monitoring.md)
- Indexing notes: see [database-adv-script/index_performance.md](database-adv-script/index_performance.md)
- Partitioning work referenced: [database-adv-script/partitioning.sql](database-adv-script/partitioning.sql) and [database-adv-script/partition_performance.md](database-adv-script/partition_performance.md)

Initial observations (EXPLAIN / EXPLAIN ANALYZE)
- The original query in [perfomance.sql](database-adv-script/perfomance.sql) performs full scans on the parent booking table when no WHERE clause is present.
- JOINS on `Booking.user_id` and `Booking.property_id` benefit from indexes; verify their presence and statistics in the schema ([database-script-0x01/schema.sql](database-script-0x01/schema.sql)).
- LEFT JOIN to `Payment` can cause nested-loop work when payments are not aggregated or when multiple payments exist per booking.
- Selecting many columns increases IO; fetching only required columns reduces row width and memory pressure.

Actions taken / Recommendations
1. Add or confirm indexes on join/filter columns (examples):
   - CREATE INDEX ON Booking(start_date);
   - CREATE INDEX ON Booking(user_id);
   - CREATE INDEX ON Booking(property_id);
   - CREATE INDEX ON Payment(booking_id);
   (See [database-adv-script/index_performance.md](database-adv-script/index_performance.md) for the index discussion.)

2. Use partitioning when querying large date ranges:
   - Implement range partitioning on `Booking.start_date` (see [database-adv-script/partitioning.sql](database-adv-script/partitioning.sql)).
   - Queries constrained by start_date will then prune partitions and reduce scanned rows (see [partition_performance.md](database-adv-script/partition_performance.md)).

3. Refactor Payment join to avoid row multiplication:
   - If Payments are one-to-many, aggregate before joining (SUM, MAX, or pick latest payment).
   - Example: join a small derived table of aggregated payments keyed by booking_id.

4. Narrow query footprint:
   - Only select needed columns.
   - Add WHERE filters (date range, status) where appropriate.

Refactored example (recommended) — aggregate payments and constrain date range
- Save this replacement or variant in [database-adv-script/perfomance.sql](database-adv-script/perfomance.sql) for benchmarking.

```sql
-- Recommended refactor: aggregate payments, limit date range for partition pruning
SELECT
  b.booking_id,
  b.start_date,
  b.end_date,
  b.total_price,
  b.status AS booking_status,
  u.user_id,
  u.first_name,
  u.last_name,
  p.property_id,
  p.name AS property_name,
  p.location,
  p.pricepernight,
  pay.total_amount,
  pay.last_payment_date,
  pay.payment_method
FROM "Booking" b
JOIN "User" u ON b.user_id = u.user_id
JOIN "Property" p ON b.property_id = p.property_id
LEFT JOIN (
  SELECT booking_id,
         SUM(amount) AS total_amount,
         MAX(payment_date) AS last_payment_date,
         -- choose an appropriate aggregation for payment_method
         MAX(payment_method) AS payment_method
  FROM "Payment"
  GROUP BY booking_id
) pay ON pay.booking_id = b.booking_id
WHERE b.start_date BETWEEN DATE '2025-01-01' AND DATE '2025-02-28';
```