# Partition Performance Report — Booking table partitioning

Summary
- Partitioning script: [database-adv-script/partitioning.sql](database-adv-script/partitioning.sql)  
- Schema reference: [`Booking`](database-script-0x01/schema.sql) in [database-script-0x01/schema.sql](database-script-0x01/schema.sql)  
- Initial query used for testing: [database-adv-script/perfomance.sql](database-adv-script/perfomance.sql)  
- Related findings: [database-adv-script/optimization_report.md](database-adv-script/optimization_report.md), [database-adv-script/performance_monitoring.md](database-adv-script/performance_monitoring.md)

Objective
- Validate that RANGE partitioning on `start_date` reduces scanned rows and improves query latency for date-range queries against the `Booking` table.

Setup
1. Apply baseline schema from [database-script-0x01/schema.sql](database-script-0x01/schema.sql) and load sample data from [database-script-0x02/seed.sql](database-script-0x02/seed.sql).
2. Capture baseline plan and timing:
   - EXPLAIN ANALYZE for date-range query (no partitioning).
3. Apply partitioning from [database-adv-script/partitioning.sql](database-adv-script/partitioning.sql).
4. Re-run the same EXPLAIN ANALYZE and compare.

Test queries
- Baseline / refactored query used for measurement (example):
  - Use the trimmed query in [database-adv-script/perfomance.sql](database-adv-script/perfomance.sql) but constrain by date range:
    - SELECT ... FROM "Booking" b ... WHERE b.start_date BETWEEN '2025-01-01' AND '2025-01-31';

Benchmark commands
- Baseline (before partitioning):
  - EXPLAIN ANALYZE <original query with date range>
- After partitioning:
  - EXPLAIN ANALYZE <same query>

Key metrics to compare
- total execution time (ms)
- number of rows returned
- planner node types (Seq Scan vs Index/Partition Prune)
- actual vs estimated rows
- whether partition pruning occurred (look for references to partition tables like "Booking_2025_01")

Observed results (expected / typical)
- Partition pruning: queries constrained to a date range scanned only relevant monthly partitions (e.g., "Booking_2025_01") instead of the whole parent table.
- Reduced scanned rows and lower execution time for date-range queries — commonly 40–90% improvement depending on data distribution and selectivity.
- Small overhead for inserts that require finding the correct partition; negligible for typical OLTP volumes but should be measured for heavy write workloads.

Recommendations
1. Use partitioning for large time-series tables where queries frequently filter by date — see [database-adv-script/partitioning.sql](database-adv-script/partitioning.sql).
2. Keep the partition key aligned with the most common filter (here `start_date`) to enable pruning.
3. Combine partitioning with indexes on join/filter columns (see [database-adv-script/index_performance.md](database-adv-script/index_performance.md) and [`Booking`](database-script-0x01/schema.sql) indexes).
4. When joining partitioned tables, ensure statistics are up-to-date (ANALYZE) so the planner can choose optimal plans.
5. Maintain a default partition for out-of-range inserts (already created in [database-adv-script/partitioning.sql](database-adv-script/partitioning.sql)).

Next steps / verification checklist
- [ ] Run EXPLAIN ANALYZE before/after and paste outputs into [database-adv-script/performance_monitoring.md](database-adv-script/performance_monitoring.md)
- [ ] Confirm partition pruning lines in the post-partition EXPLAIN
- [ ] Measure insert throughput to validate write overhead
- [ ] Add monthly partitions as data grows (automation script recommended)

References
- Partition DDL: [database-adv-script/partitioning.sql](database-adv-script/partitioning.sql)  
- Initial query used: [database-adv-script/perfomance.sql](database-adv-script/perfomance.sql)  
- Schema: [`Booking`](database-script-0x01/schema.sql) in [database-script-0x01/schema.sql](database-script-0x01/schema.sql)  
- Optimization notes: [database-adv-script/optimization_report.md](database-adv-script/optimization_report.md)  
- Monitoring doc: [database-adv-script/performance_monitoring.md](database-adv-script/performance_monitoring.md)