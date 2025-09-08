# Performance Monitoring — EXPLAIN / ANALYZE checklist & results

Purpose
- Capture and compare execution plans and timings for the initial and refactored queries that touch [`Booking`](database-script-0x01/schema.sql), [`User`](database-script-0x01/schema.sql), [`Property`](database-script-0x01/schema.sql) and [`Payment`](database-script-0x01/schema.sql).
- Tie results to the work in [database-adv-script/perfomance.sql](database-adv-script/perfomance.sql), [database-adv-script/optimization_report.md](database-adv-script/optimization_report.md), [database-adv-script/index_performance.md](database-adv-script/index_performance.md) and [database-adv-script/partition_performance.md](database-adv-script/partition_performance.md).

Files / references
- Initial query: [database-adv-script/perfomance.sql](database-adv-script/perfomance.sql)  
- Refactor & recommendations: [database-adv-script/optimization_report.md](database-adv-script/optimization_report.md)  
- Partitioning DDL: [database-adv-script/partitioning.sql](database-adv-script/partitioning.sql) and report [database-adv-script/partition_performance.md](database-adv-script/partition_performance.md)  
- Schema: [database-script-0x01/schema.sql](database-script-0x01/schema.sql)  
- Sample data: [database-script-0x02/seed.sql](database-script-0x02/seed.sql)

Workflow (minimal reproducible steps)
1. Prepare baseline
   - Ensure schema loaded: source [database-script-0x01/schema.sql](database-script-0x01/schema.sql)
   - Load sample data: run [database-script-0x02/seed.sql](database-script-0x02/seed.sql)
   - Ensure statistics up-to-date:
     - MySQL: ANALYZE TABLE Booking;
     - Postgres: ANALYZE;

2. Capture baseline plan & timing
   - MySQL 8.0+ (recommended):
     - EXPLAIN ANALYZE <query>;
   - Postgres:
     - EXPLAIN (ANALYZE, BUFFERS, VERBOSE) <query>;
   - Use the query in [database-adv-script/perfomance.sql](database-adv-script/perfomance.sql) as the baseline.

3. Apply changes iteratively
   - Add indexes (see [database-adv-script/index_performance.md](database-adv-script/index_performance.md))
   - Re-run EXPLAIN ANALYZE
   - Apply query refactor (aggregate `Payment` before join) from [database-adv-script/optimization_report.md](database-adv-script/optimization_report.md) and save variant to [database-adv-script/perfomance.sql](database-adv-script/perfomance.sql)
   - If testing partitioning: apply [database-adv-script/partitioning.sql](database-adv-script/partitioning.sql) (Postgres only) and re-run plan

4. Record and compare
   - Capture these metrics for each run:
     - total execution time
     - rows returned
     - planner node types (Seq Scan vs Index Scan vs Partition Prune)
     - actual vs estimated rows
     - CPU / IO where available
   - Paste raw EXPLAIN outputs below under the appropriate section.

Example commands
- MySQL:
```sql
-- baseline
EXPLAIN ANALYZE SELECT /* trimmed */ FROM Booking b JOIN User u ON b.user_id = u.user_id ...;

-- after index change
CREATE INDEX idx_booking_user ON Booking(user_id);
ANALYZE TABLE Booking;
EXPLAIN ANALYZE <same query>;
```