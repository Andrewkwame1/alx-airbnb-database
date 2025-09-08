# Index Performance — recommended indexes & measurement

## Purpose
- Identify high-usage columns and provide index DDL plus a short measurement checklist to compare query plans before/after.

## Recommended indexes (Postgres / MySQL compatible)
- Focus: JOIN and WHERE columns used in perfomance.sql and common queries.

### Postgres (recommended)
```sql
CREATE INDEX idx_booking_start_date ON "Booking"(start_date);
CREATE INDEX idx_booking_user_id   ON "Booking"(user_id);
CREATE INDEX idx_booking_property_id ON "Booking"(property_id);
CREATE INDEX idx_payment_booking_id ON "Payment"(booking_id);
CREATE INDEX idx_property_location ON "Property"(location);
CREATE INDEX idx_user_email ON "User"(email);
```

### MySQL (recommended)
```sql
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);
CREATE INDEX idx_property_location ON Property(location);
CREATE INDEX idx_user_email ON User(email);
```

## Notes
- Choose single-column indexes for high-selectivity filters; use composite indexes when queries filter/sort on multiple columns together (e.g., (start_date, status)).
- Avoid indexing very low-selectivity boolean flags unless combined with other columns.
- For Postgres partitioned Booking, create indexes on each partition or create a global index on the parent only when supported by your PG version.

## Measurement checklist (minimal)
1. **Prepare baseline**
   - Load schema & seed, then run ANALYZE (Postgres) or ANALYZE TABLE (MySQL).
2. **Capture baseline plan/time**
   - Postgres (from terminal): `psql -d <db> -c "EXPLAIN (ANALYZE, BUFFERS) <your query>;"`
   - MySQL (from terminal): `mysql -u <user> -p -e "EXPLAIN ANALYZE <your query>;"`

3. **Apply index(es)**
   - Run `CREATE INDEX ...` then `ANALYZE` / `ANALYZE TABLE`.
4. **Re-run EXPLAIN ANALYZE**
   - Compare total time, node types (Seq Scan → Index Scan), actual vs estimated rows, and whether partition pruning/indexes are used.
5. **Record results in `performance_monitoring.md`**

## Quick commands (Windows examples)
- **Postgres:**
  ```bash
  psql -d mydb -c "ANALYZE;"
  psql -d mydb -c "CREATE INDEX idx_booking_user_id ON \"Booking\"(user_id);"
  psql -d mydb -c "EXPLAIN (ANALYZE, BUFFERS) SELECT /* trimmed */ FROM \"Booking\" b JOIN \"User\" u ON b.user_id=u.user_id WHERE b.start_date BETWEEN '2025-01-01' AND '2025-01-31';"
  ```

- **MySQL:**
  ```bash
  mysql -u root -p -e "ANALYZE TABLE Booking;"
  mysql -u root -p -e "CREATE INDEX idx_booking_user_id ON Booking(user_id);"
  mysql -u root -p -e "EXPLAIN ANALYZE SELECT /* trimmed */ FROM Booking b JOIN User u ON b.user_id=u.user_id WHERE b.start_date BETWEEN '2025-01-01' AND '2025-01-31';"
  ```

## Rollback
- `DROP INDEX idx_booking_user_id;` (Postgres)
- `ALTER TABLE Booking DROP INDEX idx_booking_user_id;` (MySQL)

## Expected outcomes
- Reduced total execution time for date-range and join-heavy queries.
- Planner shows Index Scan or Partition Pruning instead of full Seq Scan.
- If no improvement, verify query shape and statistics (ANALYZE) and consider composite indexes or query refactor.

## References
- Map these indexes to queries in perfomance.sql and document EXPLAIN outputs in performance_monitoring.md.