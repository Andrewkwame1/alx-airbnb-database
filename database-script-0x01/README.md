# ALX Airbnb Database Schema

## Overview
Simple and clean database schema for the ALX Airbnb project with 6 main tables and essential indexes.

## Quick Setup
```sql
mysql -u root -p
source schema.sql
```

## Database Tables

### 1. User
Stores all system users (guests, hosts, admins)
```sql
- user_id (Primary Key)
- first_name, last_name, email (required)
- password_hash (required)
- phone_number (optional)
- role (guest/host/admin)
- created_at (timestamp)
```

### 2. Property
Property listings for booking
```sql
- property_id (Primary Key)
- host_id (Foreign Key → User)
- name, description, location (required)
- pricepernight (decimal)
- created_at, updated_at (timestamps)
```

### 3. Booking
Reservation records
```sql
- booking_id (Primary Key)
- property_id (Foreign Key → Property)
- user_id (Foreign Key → User)
- start_date, end_date (required)
- total_price (decimal)
- status (pending/confirmed/canceled)
- created_at (timestamp)
```

### 4. Payment
Payment transactions
```sql
- payment_id (Primary Key)
- booking_id (Foreign Key → Booking)
- amount (decimal)
- payment_date (timestamp)
- payment_method (credit_card/paypal/stripe)
```

### 5. Review
Property reviews and ratings
```sql
- review_id (Primary Key)
- property_id (Foreign Key → Property)
- user_id (Foreign Key → User)
- rating (1-5 scale)
- comment (text)
- created_at (timestamp)
```

### 6. Message
User-to-user messaging
```sql
- message_id (Primary Key)
- sender_id (Foreign Key → User)
- recipient_id (Foreign Key → User)
- message_body (text)
- sent_at (timestamp)
```

## Relationships
- User → Property (1:Many) - Users can host multiple properties
- User → Booking (1:Many) - Users can make multiple bookings
- Property → Booking (1:Many) - Properties can have multiple bookings
- Booking → Payment (1:1) - Each booking has one payment
- User → Review (1:Many) - Users can write multiple reviews
- Property → Review (1:Many) - Properties can receive multiple reviews
- User → Message (1:Many) - Users can send/receive multiple messages

## Key Features
✅ UUID primary keys for all tables  
✅ Foreign key relationships with CASCADE delete  
✅ Essential indexes for performance  
✅ ENUM constraints for status fields  
✅ Rating validation (1-5 scale)  
✅ Automatic timestamps  

## Usage Examples

### Insert Sample User
```sql
INSERT INTO User VALUES 
('550e8400-e29b-41d4-a716-446655440000', 'John', 'Doe', 'john@example.com', 'hashed_password', '+1234567890', 'host', NOW());
```

### Insert Sample Property
```sql
INSERT INTO Property VALUES 
('550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440000', 'Beach House', 'Beautiful oceanview property', 'Miami, FL', 150.00, NOW(), NOW());
```

### Query Properties by Location
```sql
SELECT * FROM Property WHERE location LIKE '%Miami%';
```

### Check User Bookings
```sql
SELECT b.*, p.name as property_name 
FROM Booking b 
JOIN Property p ON b.property_id = p.property_id 
WHERE b.user_id = 'user-id-here';
```

## Simple Maintenance
```sql
-- Check all tables
SHOW TABLES;

-- View table structure
DESCRIBE User;

-- Check foreign keys
SELECT * FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE REFERENCED_TABLE_SCHEMA = 'alx_airbnb_db';
```