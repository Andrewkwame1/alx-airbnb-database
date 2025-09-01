-- ===================================================================
-- ALX AIRBNB DATABASE - SAMPLE DATA
-- ===================================================================
-- File: seed.sql
-- Purpose: Populate database with realistic sample data
-- Usage: mysql -u username -p alx_airbnb_db < seed.sql
-- ===================================================================

-- Use the ALX Airbnb database
USE alx_airbnb_db;

-- Disable foreign key checks temporarily for easier insertion
SET FOREIGN_KEY_CHECKS = 0;

-- ===================================================================
-- INSERT SAMPLE USERS
-- ===================================================================

INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at) VALUES
-- Hosts
('550e8400-e29b-41d4-a716-446655440001', 'John', 'Smith', 'john.smith@email.com', 'hash_john_123', '+1-555-0101', 'host', '2024-01-15 10:30:00'),
('550e8400-e29b-41d4-a716-446655440002', 'Maria', 'Garcia', 'maria.garcia@email.com', 'hash_maria_456', '+1-555-0102', 'host', '2024-01-20 14:15:00'),
('550e8400-e29b-41d4-a716-446655440003', 'David', 'Johnson', 'david.johnson@email.com', 'hash_david_789', '+1-555-0103', 'host', '2024-02-01 09:45:00'),
('550e8400-e29b-41d4-a716-446655440004', 'Sarah', 'Williams', 'sarah.williams@email.com', 'hash_sarah_012', '+1-555-0104', 'host', '2024-02-10 16:20:00'),

-- Guests
('550e8400-e29b-41d4-a716-446655440005', 'Michael', 'Brown', 'michael.brown@email.com', 'hash_michael_345', '+1-555-0105', 'guest', '2024-02-15 11:00:00'),
('550e8400-e29b-41d4-a716-446655440006', 'Emily', 'Davis', 'emily.davis@email.com', 'hash_emily_678', '+1-555-0106', 'guest', '2024-02-20 13:30:00'),
('550e8400-e29b-41d4-a716-446655440007', 'James', 'Miller', 'james.miller@email.com', 'hash_james_901', '+1-555-0107', 'guest', '2024-03-01 08:15:00'),
('550e8400-e29b-41d4-a716-446655440008', 'Lisa', 'Wilson', 'lisa.wilson@email.com', 'hash_lisa_234', '+1-555-0108', 'guest', '2024-03-05 12:45:00'),
('550e8400-e29b-41d4-a716-446655440009', 'Robert', 'Moore', 'robert.moore@email.com', 'hash_robert_567', '+1-555-0109', 'guest', '2024-03-10 15:20:00'),
('550e8400-e29b-41d4-a716-446655440010', 'Jessica', 'Taylor', 'jessica.taylor@email.com', 'hash_jessica_890', '+1-555-0110', 'guest', '2024-03-15 10:10:00'),

-- Admin
('550e8400-e29b-41d4-a716-446655440011', 'Admin', 'User', 'admin@alxairbnb.com', 'hash_admin_secure', '+1-555-0111', 'admin', '2024-01-01 00:00:00');

-- ===================================================================
-- INSERT SAMPLE PROPERTIES
-- ===================================================================

INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at) VALUES
-- John Smith's Properties
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440001', 'Cozy Downtown Apartment', 'Modern 2-bedroom apartment in the heart of downtown with amazing city views. Walking distance to restaurants and shopping.', 'New York, NY', 125.00, '2024-01-16 11:00:00', '2024-01-16 11:00:00'),

('650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', 'Brooklyn Loft', 'Spacious industrial loft in trendy Brooklyn neighborhood. Perfect for creative professionals and groups.', 'Brooklyn, NY', 180.00, '2024-01-18 14:30:00', '2024-01-18 14:30:00'),

-- Maria Garcia's Properties
('650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440002', 'Beach House Paradise', 'Stunning oceanfront house with private beach access. Perfect for family vacations and romantic getaways.', 'Miami, FL', 250.00, '2024-01-22 16:45:00', '2024-01-22 16:45:00'),

('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440002', 'Art Deco Studio', 'Charming studio apartment in historic Art Deco building. Located in South Beach with easy access to nightlife.', 'Miami, FL', 95.00, '2024-01-25 09:15:00', '2024-01-25 09:15:00'),

-- David Johnson's Properties
('650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440003', 'Mountain Cabin Retreat', 'Rustic log cabin nestled in the mountains. Fireplace, hot tub, and hiking trails nearby. Pet-friendly!', 'Aspen, CO', 200.00, '2024-02-02 12:20:00', '2024-02-02 12:20:00'),

('650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440003', 'Ski Lodge Suite', 'Luxury suite in premier ski lodge. Ski-in/ski-out access and world-class amenities.', 'Aspen, CO', 350.00, '2024-02-05 08:50:00', '2024-02-05 08:50:00'),

-- Sarah Williams's Properties
('650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440004', 'Hollywood Hills Villa', 'Modern villa with infinity pool overlooking Los Angeles. Celebrity-style luxury and privacy.', 'Los Angeles, CA', 400.00, '2024-02-12 13:40:00', '2024-02-12 13:40:00'),

('650e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440004', 'Venice Beach Bungalow', 'Bohemian beach bungalow steps from the famous Venice Beach boardwalk. Unique artistic decor.', 'Los Angeles, CA', 150.00, '2024-02-15 17:25:00', '2024-02-15 17:25:00');

-- ===================================================================
-- INSERT SAMPLE BOOKINGS
-- ===================================================================

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
-- Confirmed Bookings
('750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440005', '2024-04-15', '2024-04-18', 375.00, 'confirmed', '2024-03-15 10:30:00'),

('750e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440006', '2024-05-01', '2024-05-07', 1500.00, 'confirmed', '2024-03-20 14:45:00'),

('750e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440007', '2024-06-10', '2024-06-15', 1000.00, 'confirmed', '2024-04-01 09:15:00'),

('750e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440008', '2024-07-01', '2024-07-05', 1600.00, 'confirmed', '2024-05-15 16:20:00'),

('750e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440009', '2024-08-12', '2024-08-16', 720.00, 'confirmed', '2024-06-10 11:45:00'),

-- Pending Bookings
('750e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440010', '2024-09-20', '2024-09-25', 475.00, 'pending', '2024-08-15 13:30:00'),

('750e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440005', '2024-12-15', '2024-12-20', 1750.00, 'pending', '2024-08-20 08:20:00'),

-- Canceled Booking
('750e8400-e29b-41d4-a716-446655440008', '650e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440006', '2024-10-01', '2024-10-05', 600.00, 'canceled', '2024-07-01 15:10:00'),

-- Recent Bookings
('750e8400-e29b-41d4-a716-446655440009', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440007', '2025-01-15', '2025-01-20', 625.00, 'confirmed', '2024-12-01 12:00:00'),

('750e8400-e29b-41d4-a716-446655440010', '650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440009', '2025-02-10', '2025-02-17', 1750.00, 'pending', '2024-12-15 14:30:00');

-- ===================================================================
-- INSERT SAMPLE PAYMENTS
-- ===================================================================

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method) VALUES
-- Payments for Confirmed Bookings
('850e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440001', 375.00, '2024-03-15 10:35:00', 'credit_card'),

('850e8400-e29b-41d4-a716-446655440002', '750e8400-e29b-41d4-a716-446655440002', 1500.00, '2024-03-20 14:50:00', 'paypal'),

('850e8400-e29b-41d4-a716-446655440003', '750e8400-e29b-41d4-a716-446655440003', 1000.00, '2024-04-01 09:20:00', 'stripe'),

('850e8400-e29b-41d4-a716-446655440004', '750e8400-e29b-41d4-a716-446655440004', 1600.00, '2024-05-15 16:25:00', 'credit_card'),

('850e8400-e29b-41d4-a716-446655440005', '750e8400-e29b-41d4-a716-446655440005', 720.00, '2024-06-10 11:50:00', 'paypal'),

-- Payment for Recent Booking
('850e8400-e29b-41d4-a716-446655440006', '750e8400-e29b-41d4-a716-446655440009', 625.00, '2024-12-01 12:05:00', 'stripe');

-- ===================================================================
-- INSERT SAMPLE REVIEWS
-- ===================================================================

INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at) VALUES
-- Reviews for completed stays
('950e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440005', 5, 'Amazing apartment! Perfect location in downtown with great city views. John was a fantastic host - very responsive and helpful. Would definitely stay here again!', '2024-04-20 16:30:00'),

('950e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440006', 5, 'Absolutely stunning beach house! Woke up to ocean views every morning. The private beach access was incredible. Maria provided everything we needed for a perfect vacation.', '2024-05-10 14:15:00'),

('950e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440007', 4, 'Beautiful mountain cabin with great amenities. The hot tub was perfect after hiking. Only minor issue was WiFi was a bit slow, but that actually helped us disconnect and enjoy nature!', '2024-06-18 11:45:00'),

('950e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440008', 5, 'Luxury at its finest! The infinity pool and views over LA were breathtaking. Sarah was an excellent host with great local recommendations. Worth every penny!', '2024-07-08 19:20:00'),

('950e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440009', 4, 'Cool industrial loft in a great Brooklyn neighborhood. Loved the artistic vibe and local cafes nearby. Apartment was clean and well-equipped. Great for our group trip!', '2024-08-20 13:10:00'),

('950e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440009', 5, 'Second time staying at John\'s place and it never disappoints! Perfect for business trips to NYC. Great transportation access and comfortable bed. Highly recommend!', '2024-12-10 09:30:00'),

-- A few more diverse reviews
('950e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440007', 3, 'Decent studio in a good location. The building is beautiful and historic. However, the space was smaller than expected and could use some updates. Still had a good time in Miami!', '2024-03-25 15:45:00'),

('950e8400-e29b-41d4-a716-446655440008', '650e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440005', 4, 'Loved the bohemian vibe of this Venice Beach bungalow! So close to the beach and boardwalk. The decor is unique and artistic. Great place to experience the Venice culture.', '2024-02-28 12:20:00');

-- ===================================================================
-- INSERT SAMPLE MESSAGES
-- ===================================================================

INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
-- Booking inquiries and communication
('a50e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', 'Hi John! I\'m interested in booking your downtown apartment for April 15-18. Is it available? Also, is parking included?', '2024-03-10 14:30:00'),

('a50e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440005', 'Hi Michael! Yes, the apartment is available for those dates. Parking is available for $20/night in the building garage. Let me know if you\'d like to book!', '2024-03-10 16:45:00'),

('a50e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', 'Perfect! I\'ll take it. How do I proceed with the booking?', '2024-03-11 09:15:00'),

('a50e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440002', 'Hello Maria! Your beach house looks amazing. We\'re a group of 6 friends looking to stay May 1-7. Do you allow groups?', '2024-03-15 11:20:00'),

('a50e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440006', 'Hi Emily! Absolutely, groups are welcome! The house sleeps 8 comfortably. I just ask that you respect the property and neighbors. Beach access is private!', '2024-03-15 13:45:00'),

('a50e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440003', 'Hi David! Planning a mountain getaway in June. Is the cabin pet-friendly? We have a well-behaved golden retriever.', '2024-03-28 16:30:00'),

('a50e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440007', 'Hi James! Yes, the cabin is pet-friendly! There\'s a small pet fee of $25/night. Your golden will love the hiking trails nearby. There\'s even a dog park in town!', '2024-03-28 18:15:00'),

-- Check-in instructions and updates
('a50e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440005', 'Hi Michael! Just wanted to send check-in details. The building code is 1234 and apartment key is in lockbox 5B (code: 5678). Check-in after 3pm. Let me know when you arrive!', '2024-04-14 12:00:00'),

('a50e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440001', 'Thanks John! Just arrived and got the keys. The apartment is even better than the photos! Thanks for the restaurant recommendations too.', '2024-04-15 15:30:00'),

-- Post-stay follow-up
('a50e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440006', 'Hi Emily! Hope you had a wonderful stay at the beach house! Would love a review if you have time. Thanks for being such great guests!', '2024-05-08 10:30:00'),

('a50e8400-e29b-41d4-a716-446655440011', '550e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440002', 'Maria, we had an absolutely amazing time! The house exceeded all our expectations. Just left a 5-star review. Thank you for making our vacation perfect!', '2024-05-08 14:20:00');

-- ===================================================================
-- RE-ENABLE FOREIGN KEY CHECKS
-- ===================================================================

SET FOREIGN_KEY_CHECKS = 1;

-- ===================================================================
-- VERIFY DATA INSERTION
-- ===================================================================

-- Display summary of inserted data
SELECT 'Users' as Table_Name, COUNT(*) as Record_Count FROM User
UNION ALL
SELECT 'Properties', COUNT(*) FROM Property
UNION ALL
SELECT 'Bookings', COUNT(*) FROM Booking
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payment
UNION ALL
SELECT 'Reviews', COUNT(*) FROM Review
UNION ALL
SELECT 'Messages', COUNT(*) FROM Message;
