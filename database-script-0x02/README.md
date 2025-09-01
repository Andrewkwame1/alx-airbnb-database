# ALX Airbnb Database - Sample Data

## Overview
This directory contains SQL scripts to populate the ALX Airbnb database with realistic sample data for testing and development.

## Files
- `seed.sql` - Complete SQL script with sample data
- `README.md` - This documentation file

## Quick Setup
```bash
# Run the seed script
mysql -u username -p alx_airbnb_db < seed.sql
```

## Sample Data Summary

### 📊 Data Statistics
- **Users**: 11 total (4 hosts, 6 guests, 1 admin)
- **Properties**: 8 properties across 4 cities
- **Bookings**: 10 bookings (various statuses)
- **Payments**: 6 completed payments
- **Reviews**: 8 detailed reviews (3-5 star ratings)
- **Messages**: 11 realistic conversations

## 👥 Sample Users

### Hosts
1. **John Smith** - New York properties (Downtown Apartment, Brooklyn Loft)
2. **Maria Garcia** - Miami properties (Beach House, Art Deco Studio)
3. **David Johnson** - Aspen properties (Mountain Cabin, Ski Lodge)
4. **Sarah Williams** - Los Angeles properties (Hollywood Villa, Venice Bungalow)

### Guests
- Michael Brown, Emily Davis, James Miller, Lisa Wilson, Robert Moore, Jessica Taylor

### Admin
- Admin User (system administrator)

## 🏠 Sample Properties

### New York
- **Cozy Downtown Apartment** ($125/night) - Modern 2-bedroom with city views
- **Brooklyn Loft** ($180/night) - Industrial loft in trendy neighborhood

### Miami
- **Beach House Paradise** ($250/night) - Oceanfront with private beach
- **Art Deco Studio** ($95/night) - Historic South Beach location

### Aspen
- **Mountain Cabin Retreat** ($200/night) - Rustic cabin with hot tub
- **Ski Lodge Suite** ($350/night) - Luxury ski-in/ski-out access

### Los Angeles
- **Hollywood Hills Villa** ($400/night) - Modern villa with infinity pool
- **Venice Beach Bungalow** ($150/night) - Bohemian beachside location

## 📅 Sample Bookings

### Booking Status Distribution
- **Confirmed**: 6 bookings with payments
- **Pending**: 3 bookings awaiting confirmation
- **Canceled**: 1 canceled booking

### Date Range Examples
- Short stays (3-4 days) and week-long vacations
- Bookings from April 2024 to February 2025
- Realistic pricing based on duration and property rates

## 💳 Payment Methods
- **Credit Card**: 3 payments
- **PayPal**: 2 payments  
- **Stripe**: 1 payment

## ⭐ Review Examples
- **5 Stars**: Premium experiences (Beach House, Hollywood Villa)
- **4 Stars**: Great stays with minor notes (Mountain Cabin, Brooklyn Loft)
- **3 Stars**: Good but with improvement suggestions (Art Deco Studio)

## 💬 Message Conversations

### Conversation Types
1. **Booking Inquiries** - Initial interest and availability questions
2. **Property Details** - Specific questions about amenities (parking, pets)
3. **Check-in Instructions** - Access codes and arrival details
4. **Post-stay Follow-up** - Review requests and thank you messages

## 🔍 Useful Queries

### View All Properties with Host Info
```sql
SELECT p.name, p.location, p.pricepernight, 
       CONCAT(u.first_name, ' ', u.last_name) as host_name
FROM Property p 
JOIN User u ON p.host_id = u.user_id;
```

### Check Booking Summary
```sql
SELECT b.start_date, b.end_date, b.total_price, b.status,
       p.name as property, 
       CONCAT(u.first_name, ' ', u.last_name) as guest_name
FROM Booking b 
JOIN Property p ON b.property_id = p.property_id 
JOIN User u ON b.user_id = u.user_id
ORDER BY b.created_at DESC;
```

### View Property Reviews
```sql
SELECT p.name, r.rating, r.comment, 
       CONCAT(u.first_name, ' ', u.last_name) as reviewer
FROM Review r 
JOIN Property p ON r.property_id = p.property_id 
JOIN User u ON r.user_id = u.user_id
ORDER BY r.created_at DESC;
```

### Message Conversations
```sql
SELECT m.sent_at, 
       CONCAT(s.first_name, ' ', s.last_name) as sender,
       CONCAT(r.first_name, ' ', r.last_name) as recipient,
       LEFT(m.message_body, 50) as message_preview
FROM Message m 
JOIN User s ON m.sender_id = s.user_id 
JOIN User r ON m.recipient_id = r.user_id
ORDER BY m.sent_at DESC;
```

## 📈 Business Analytics Queries

### Top Rated Properties
```sql
SELECT p.name, p.location, AVG(r.rating) as avg_rating, COUNT(r.rating) as review_count
FROM Property p 
LEFT JOIN Review r ON p.property_id = r.property_id 
GROUP BY p.property_id 
ORDER BY avg_rating DESC, review_count DESC;
```

### Revenue by Host
```sql
SELECT CONCAT(u.first_name, ' ', u.last_name) as host_name,
       COUNT(b.booking_id) as total_bookings,
       SUM(b.total_price) as total_revenue
FROM User u 
JOIN Property p ON u.user_id = p.host_id 
JOIN Booking b ON p.property_id = b.property_id 
WHERE b.status = 'confirmed'
GROUP BY u.user_id
ORDER BY total_revenue DESC;
```

### Popular Locations
```sql
SELECT location, COUNT(*) as property_count, AVG(pricepernight) as avg_price
FROM Property 
GROUP BY location 
ORDER BY property_count DESC;
```

## 🎯 Data Features

### Realistic Relationships
- ✅ Hosts don't book their own properties
- ✅ Payments match confirmed bookings  
- ✅ Reviews from actual guests who stayed
- ✅ Messages show realistic host-guest communication

### Diverse Scenarios
- ✅ Different property types and price ranges
- ✅ Various booking lengths and seasons
- ✅ Multiple payment methods
- ✅ Range of review ratings and feedback
- ✅ Both individual and group bookings

### Business Logic
- ✅ All foreign key relationships maintained
- ✅ Realistic pricing calculations
- ✅ Date ranges make logical sense
- ✅ Payment amounts match booking totals
- ✅ Review dates after booking completion

## 🛠️ Testing Scenarios

### User Role Testing
```sql
-- Test host properties
SELECT COUNT(*) as host_properties 
FROM Property p 
JOIN User u ON p.host_id = u.user_id 
WHERE u.role = 'host';

-- Test guest bookings
SELECT COUNT(*) as guest_bookings 
FROM Booking b 
JOIN User u ON b.user_id = u.user_id 
WHERE u.role = 'guest';
```

### Booking Status Validation
```sql
-- Check booking statuses
SELECT status, COUNT(*) as count 
FROM Booking 
GROUP BY status;

-- Verify payments for confirmed bookings
SELECT b.status, COUNT(p.payment_id) as payment_count
FROM Booking b 
LEFT JOIN Payment p ON b.booking_id = p.booking_id 
GROUP BY b.status;
```

### Review Rating Distribution
```sql
-- Check rating spread
SELECT rating, COUNT(*) as count 
FROM Review 
GROUP BY rating 
ORDER BY rating;
```

## 🔧 Customization

### Adding More Data
To add additional sample data, follow these patterns:

#### New User
```sql
INSERT INTO User VALUES 
('new-uuid-here', 'First', 'Last', 'email@example.com', 'hashed_password', '+1-555-0000', 'guest', NOW());
```

#### New Property
```sql
INSERT INTO Property VALUES 
('new-uuid-here', 'host-user-id', 'Property Name', 'Description here', 'City, State', 100.00, NOW(), NOW());
```

#### New Booking
```sql
INSERT INTO Booking VALUES 
('new-uuid-here', 'property-id', 'user-id', '2025-06-01', '2025-06-05', 400.00, 'pending', NOW());
```

### UUID Generation
For new records, you can generate UUIDs using:
- Online UUID generators
- MySQL `UUID()` function
- Programming language UUID libraries

## 📋 Data Validation Checklist

### Before Running seed.sql
- [ ] Database schema is created (`schema.sql` executed)
- [ ] Database connection is working
- [ ] User has INSERT privileges
- [ ] Foreign key constraints are enabled

### After Running seed.sql
- [ ] All 11 users inserted
- [ ] All 8 properties have valid host relationships
- [ ] All 10 bookings reference valid properties and users
- [ ] All 6 payments correspond to confirmed bookings
- [ ] All 8 reviews are from users who made bookings
- [ ] All 11 messages are between valid users

### Verification Commands
```sql
-- Check for any orphaned records
SELECT 'Orphaned Properties' as issue, COUNT(*) as count
FROM Property p 
LEFT JOIN User u ON p.host_id = u.user_id 
WHERE u.user_id IS NULL

UNION ALL

SELECT 'Orphaned Bookings', COUNT(*)
FROM Booking b 
LEFT JOIN Property p ON b.property_id = p.property_id 
LEFT JOIN User u ON b.user_id = u.user_id 
WHERE p.property_id IS NULL OR u.user_id IS NULL

UNION ALL

SELECT 'Orphaned Payments', COUNT(*)
FROM Payment pay 
LEFT JOIN Booking b ON pay.booking_id = b.booking_id 
WHERE b.booking_id IS NULL;
```

## 🚀 Performance Testing

### Load Testing Queries
Use the sample data to test database performance:

```sql
-- Test complex JOIN performance
SELECT p.name, p.location, 
       AVG(r.rating) as avg_rating,
       COUNT(b.booking_id) as total_bookings,
       SUM(CASE WHEN b.status = 'confirmed' THEN b.total_price ELSE 0 END) as revenue
FROM Property p 
LEFT JOIN Review r ON p.property_id = r.property_id 
LEFT JOIN Booking b ON p.property_id = b.property_id 
GROUP BY p.property_id;

-- Test date range queries
SELECT * FROM Booking 
WHERE start_date BETWEEN '2024-06-01' AND '2024-08-31' 
ORDER BY start_date;

-- Test text search simulation
SELECT * FROM Property 
WHERE description LIKE '%beach%' OR location LIKE '%Miami%';
```

## 🔄 Reset Data

### Clear All Sample Data
```sql
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Message;
TRUNCATE TABLE Review;
TRUNCATE TABLE Payment;
TRUNCATE TABLE Booking;
TRUNCATE TABLE Property;
TRUNCATE TABLE User;
SET FOREIGN_KEY_CHECKS = 1;
```

### Re-run Seed Script
```bash
mysql -u username -p alx_airbnb_db < seed.sql
```

## 📝 Notes

- All sample data uses realistic names, locations, and scenarios
- UUID values are manually generated for consistency
- Timestamps follow logical chronological order
- Phone numbers use standard US format (+1-555-xxxx)
- Email addresses use example.com domain
- Passwords are represented as hashed values (not real hashes)

## 🎉 Ready to Use!

The sample data provides a complete, realistic dataset for:
- 🧪 **Testing** application functionality
- 🎨 **Development** and UI design
- 📊 **Analytics** and reporting features
- 🔍 **Search** and filtering capabilities
- 📱 **Demo** presentations and prototypes