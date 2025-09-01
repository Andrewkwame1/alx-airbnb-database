# ALX Airbnb Database - Normalization Analysis

## Overview
This document analyzes the ALX Airbnb database schema for normalization compliance and ensures all tables meet Third Normal Form (3NF) requirements. The analysis includes identification of potential redundancies, violations, and recommended adjustments.

## Current Database Schema Analysis

### Original Schema Review

#### 1. User Table
```sql
User (
    user_id (PK, UUID),
    first_name (VARCHAR),
    last_name (VARCHAR), 
    email (VARCHAR, UNIQUE),
    password_hash (VARCHAR),
    phone_number (VARCHAR),
    role (ENUM: guest, host, admin),
    created_at (TIMESTAMP)
)
```

#### 2. Property Table
```sql
Property (
    property_id (PK, UUID),
    host_id (FK → User.user_id),
    name (VARCHAR),
    description (TEXT),
    location (VARCHAR),
    pricepernight (DECIMAL),
    created_at (TIMESTAMP),
    updated_at (TIMESTAMP)
)
```

#### 3. Booking Table
```sql
Booking (
    booking_id (PK, UUID),
    property_id (FK → Property.property_id),
    user_id (FK → User.user_id),
    start_date (DATE),
    end_date (DATE),
    total_price (DECIMAL),
    status (ENUM: pending, confirmed, canceled),
    created_at (TIMESTAMP)
)
```

#### 4. Payment Table
```sql
Payment (
    payment_id (PK, UUID),
    booking_id (FK → Booking.booking_id),
    amount (DECIMAL),
    payment_date (TIMESTAMP),
    payment_method (ENUM: credit_card, paypal, stripe)
)
```

#### 5. Review Table
```sql
Review (
    review_id (PK, UUID),
    property_id (FK → Property.property_id),
    user_id (FK → User.user_id),
    rating (INTEGER, CHECK: 1-5),
    comment (TEXT),
    created_at (TIMESTAMP)
)
```

#### 6. Message Table
```sql
Message (
    message_id (PK, UUID),
    sender_id (FK → User.user_id),
    recipient_id (FK → User.user_id),
    message_body (TEXT),
    sent_at (TIMESTAMP)
)
```

## Normalization Forms Analysis

### First Normal Form (1NF) Analysis
**Definition**: Each table cell contains only atomic (indivisible) values, and each record is unique.

**Current Status**: ✅ **COMPLIANT**
- All attributes contain atomic values
- No repeating groups or multi-valued attributes
- Each table has a proper primary key ensuring unique records
- No composite attributes that need decomposition

### Second Normal Form (2NF) Analysis
**Definition**: Must be in 1NF and all non-key attributes must be fully functionally dependent on the entire primary key.

**Current Status**: ✅ **COMPLIANT**
- All tables use single-attribute primary keys (UUIDs)
- No composite primary keys exist, eliminating partial dependency issues
- All non-key attributes depend entirely on their respective primary keys

### Third Normal Form (3NF) Analysis
**Definition**: Must be in 2NF and no transitive dependencies exist (non-key attributes should not depend on other non-key attributes).

**Current Status**: ⚠️ **REQUIRES MINOR ADJUSTMENTS**

## Identified Issues and Normalization Steps

### Issue 1: Location Redundancy in Property Table
**Problem**: The `location` field in the Property table stores location as a single VARCHAR, which could lead to:
- Inconsistent location formats
- Difficulty in location-based searches
- Potential redundancy if multiple properties share the same location

**Solution**: Create a separate Location entity
```sql
-- New Location Table
Location (
    location_id (PK, UUID),
    city (VARCHAR, NOT NULL),
    state (VARCHAR, NOT NULL),
    country (VARCHAR, NOT NULL),
    address (VARCHAR),
    postal_code (VARCHAR),
    latitude (DECIMAL),
    longitude (DECIMAL),
    created_at (TIMESTAMP)
)

-- Updated Property Table
Property (
    property_id (PK, UUID),
    host_id (FK → User.user_id),
    location_id (FK → Location.location_id),
    name (VARCHAR),
    description (TEXT),
    pricepernight (DECIMAL),
    created_at (TIMESTAMP),
    updated_at (TIMESTAMP)
)
```

### Issue 2: Potential Total Price Redundancy in Booking Table
**Problem**: The `total_price` in Booking table can be calculated from:
- Property's `pricepernight`
- Booking duration (`end_date - start_date`)
- This creates a potential source of data inconsistency

**Analysis**: While this could be considered a violation of 3NF, keeping `total_price` is recommended because:
- Historical pricing accuracy (property prices may change)
- Performance optimization (avoiding recalculation)
- Business requirement for price freezing at booking time

**Solution**: Keep `total_price` but add validation constraints to ensure consistency.

### Issue 3: Payment Amount vs Booking Total Price
**Problem**: Payment `amount` and Booking `total_price` should always match, creating potential redundancy.

**Solution**: This is acceptable because:
- Payment represents actual transaction amount
- Booking total_price represents agreed amount
- These may differ in cases of refunds, partial payments, or discounts

## Recommended Normalized Schema

### Updated Schema Structure

#### 1. User Table (No Changes Required)
```sql
User (
    user_id (PK, UUID),
    first_name (VARCHAR, NOT NULL),
    last_name (VARCHAR, NOT NULL),
    email (VARCHAR, UNIQUE, NOT NULL),
    password_hash (VARCHAR, NOT NULL),
    phone_number (VARCHAR),
    role (ENUM: guest, host, admin, NOT NULL),
    created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
)
```

#### 2. Location Table (New)
```sql
Location (
    location_id (PK, UUID),
    city (VARCHAR, NOT NULL),
    state (VARCHAR, NOT NULL),
    country (VARCHAR, NOT NULL),
    address (VARCHAR),
    postal_code (VARCHAR),
    latitude (DECIMAL(10,8)),
    longitude (DECIMAL(11,8)),
    created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
)
```

#### 3. Property Table (Updated)
```sql
Property (
    property_id (PK, UUID),
    host_id (FK → User.user_id, NOT NULL),
    location_id (FK → Location.location_id, NOT NULL),
    name (VARCHAR, NOT NULL),
    description (TEXT, NOT NULL),
    pricepernight (DECIMAL(10,2), NOT NULL),
    created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP),
    updated_at (TIMESTAMP, ON UPDATE CURRENT_TIMESTAMP)
)
```

#### 4. Booking Table (No Changes Required)
```sql
Booking (
    booking_id (PK, UUID),
    property_id (FK → Property.property_id, NOT NULL),
    user_id (FK → User.user_id, NOT NULL),
    start_date (DATE, NOT NULL),
    end_date (DATE, NOT NULL),
    total_price (DECIMAL(10,2), NOT NULL),
    status (ENUM: pending, confirmed, canceled, NOT NULL),
    created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
)
```

#### 5. Payment Table (No Changes Required)
```sql
Payment (
    payment_id (PK, UUID),
    booking_id (FK → Booking.booking_id, NOT NULL),
    amount (DECIMAL(10,2), NOT NULL),
    payment_date (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP),
    payment_method (ENUM: credit_card, paypal, stripe, NOT NULL)
)
```

#### 6. Review Table (No Changes Required)
```sql
Review (
    review_id (PK, UUID),
    property_id (FK → Property.property_id, NOT NULL),
    user_id (FK → User.user_id, NOT NULL),
    rating (INTEGER, CHECK: rating >= 1 AND rating <= 5, NOT NULL),
    comment (TEXT, NOT NULL),
    created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
)
```

#### 7. Message Table (No Changes Required)
```sql
Message (
    message_id (PK, UUID),
    sender_id (FK → User.user_id, NOT NULL),
    recipient_id (FK → User.user_id, NOT NULL),
    message_body (TEXT, NOT NULL),
    sent_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
)
```

## Updated Entity Relationships

### New Relationships Added:
- **Location to Property**: One-to-Many (1:N)
  - One location can have multiple properties
  - Each property belongs to exactly one location

### Existing Relationships (Unchanged):
- **User to Property**: One-to-Many (1:N) - User hosts Properties
- **User to Booking**: One-to-Many (1:N) - User makes Bookings
- **Property to Booking**: One-to-Many (1:N) - Property has Bookings
- **Booking to Payment**: One-to-One (1:1) - Booking has Payment
- **User to Review**: One-to-Many (1:N) - User writes Reviews
- **Property to Review**: One-to-Many (1:N) - Property receives Reviews
- **User to Message**: One-to-Many (1:N) - User sends/receives Messages

## Benefits of Normalization

### 1. Data Consistency
- Eliminates location data redundancy
- Ensures consistent location formatting
- Reduces data anomalies

### 2. Storage Efficiency
- Reduces storage space by eliminating duplicate location data
- Enables better data compression

### 3. Maintenance Efficiency
- Location updates only need to be made in one place
- Easier to maintain location-related data integrity

### 4. Query Performance
- Enhanced location-based search capabilities
- Better indexing opportunities for geographic queries
- Improved join performance for location-related queries

## Verification of 3NF Compliance

### Final 3NF Check:
✅ **All tables now comply with 3NF**:
1. **1NF**: All tables contain atomic values with unique records
2. **2NF**: All non-key attributes fully depend on primary keys
3. **3NF**: No transitive dependencies exist between non-key attributes

### Functional Dependencies:
- **Location**: location_id → {city, state, country, address, postal_code, latitude, longitude}
- **Property**: property_id → {host_id, location_id, name, description, pricepernight}
- **User**: user_id → {first_name, last_name, email, password_hash, phone_number, role}
- **Booking**: booking_id → {property_id, user_id, start_date, end_date, total_price, status}
- **Payment**: payment_id → {booking_id, amount, payment_date, payment_method}
- **Review**: review_id → {property_id, user_id, rating, comment}
- **Message**: message_id → {sender_id, recipient_id, message_body, sent_at}

## Conclusion

The ALX Airbnb database schema has been successfully normalized to Third Normal Form (3NF) with the addition of a Location entity. This normalization:

1. **Eliminates redundancy** in location data storage
2. **Improves data integrity** and consistency
3. **Enhances maintainability** of location-related information
4. **Maintains all business logic** and functional requirements
5. **Preserves performance** for critical operations

The normalized schema is now ready for implementation and will provide a solid foundation for the Airbnb-like application with optimal data organization and minimal redundancy.