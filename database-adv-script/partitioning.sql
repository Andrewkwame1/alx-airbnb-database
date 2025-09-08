-- Create extension for UUID generation if available (pgcrypto); handle lack of privileges gracefully
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'pgcrypto') THEN
    BEGIN
      CREATE EXTENSION IF NOT EXISTS pgcrypto;
    EXCEPTION WHEN insufficient_privilege THEN
      RAISE NOTICE 'WARNING: could not create pgcrypto extension (insufficient privileges). Ensure gen_random_uuid() is available or replace with uuid_generate_v4() / client-generated UUIDs.';
    END;
  END IF;
END
$$;

-- Safely rename existing Booking to backup (if exists)
ALTER TABLE IF EXISTS "Booking" RENAME TO "Booking_backup";

-- Create enum type only if not exists
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'booking_status') THEN
    CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'canceled');
  END IF;
END
$$;

-- Create parent partitioned table
CREATE TABLE IF NOT EXISTS "Booking" (
  booking_id UUID NOT NULL DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL,
  property_id UUID NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price NUMERIC(10,2) NOT NULL,
  status booking_status NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT booking_pk PRIMARY KEY (booking_id, start_date),
  -- Ensure referenced tables/columns exist; adjust quoting to match your schema
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES "User"(user_id),
  CONSTRAINT fk_property FOREIGN KEY (property_id) REFERENCES "Property"(property_id)
) PARTITION BY RANGE (start_date);

-- Create monthly partitions (use IF NOT EXISTS)
CREATE TABLE IF NOT EXISTS "Booking_2025_01" PARTITION OF "Booking"
  FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

CREATE TABLE IF NOT EXISTS "Booking_2025_02" PARTITION OF "Booking"
  FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');

-- Default partition for out-of-range rows
CREATE TABLE IF NOT EXISTS "Booking_default" PARTITION OF "Booking" DEFAULT;

-- Helpful indexes: creating on parent will create per-partition indexes (Postgres 11+)
CREATE INDEX IF NOT EXISTS idx_booking_user_id ON "Booking"(user_id);
CREATE INDEX IF NOT EXISTS idx_booking_property_id ON "Booking"(property_id);
CREATE INDEX IF NOT EXISTS idx_booking_start_date ON "Booking"(start_date);

-- NOTE: if you renamed an existing Booking table above, migrate data manually:
-- 1) Inspect "Booking_backup" for column compatibility.
-- 2) Run (example):
--    INSERT INTO "Booking" (booking_id, user_id, property_id, start_date, end_date, total_price, status, created_at)
--    SELECT booking_id, user_id, property_id, start_date, end_date, total_price, status, created_at
--    FROM "Booking_backup";
-- 3) Verify constraints and run ANALYZE;
-- 4) Drop backup after verification: DROP TABLE "Booking_backup";
-- Always run these steps in a transaction and test on a non-production copy first.