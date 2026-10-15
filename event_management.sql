-- Smart Event Management System
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS smart_event_db;
USE smart_event_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Tickets;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Attendees;
DROP TABLE IF EXISTS Organizers;
DROP TABLE IF EXISTS Venues;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Venues
CREATE TABLE Venues (
    venue_id INT PRIMARY KEY AUTO_INCREMENT,
    venue_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0)
);

-- 2. Organizers
CREATE TABLE Organizers (
    organizer_id INT PRIMARY KEY AUTO_INCREMENT,
    organizer_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(120) UNIQUE,
    phone_number VARCHAR(20)
);

-- 3. Attendees
CREATE TABLE Attendees (
    attendee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE,
    phone_number VARCHAR(20)
);

-- 4. Events
CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(150) NOT NULL,
    event_date DATETIME NOT NULL,
    venue_id INT NOT NULL,
    organizer_id INT NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL CHECK (ticket_price >= 0),
    total_seats INT NOT NULL CHECK (total_seats > 0),
    available_seats INT NOT NULL,
    CONSTRAINT fk_events_venue FOREIGN KEY (venue_id) REFERENCES Venues(venue_id),
    CONSTRAINT fk_events_organizer FOREIGN KEY (organizer_id) REFERENCES Organizers(organizer_id),
    CONSTRAINT chk_available_seats CHECK (available_seats >= 0 AND available_seats <= total_seats)
);

-- 5. Tickets: a person can book a given event only once.
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT NOT NULL,
    attendee_id INT NOT NULL,
    booking_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Confirmed', 'Cancelled', 'Pending') NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_tickets_event FOREIGN KEY (event_id) REFERENCES Events(event_id),
    CONSTRAINT fk_tickets_attendee FOREIGN KEY (attendee_id) REFERENCES Attendees(attendee_id),
    CONSTRAINT uq_attendee_event UNIQUE (attendee_id, event_id)
);

-- 6. Payments
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL CHECK (amount_paid >= 0),
    payment_status ENUM('Success', 'Failed', 'Pending') NOT NULL DEFAULT 'Pending',
    payment_date DATETIME,
    CONSTRAINT fk_payments_ticket FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);

-- Sample data
INSERT INTO Venues (venue_name, location, capacity) VALUES
('Surat Convention Hall', 'Surat', 500),
('Riverfront Auditorium', 'Ahmedabad', 300),
('City Sports Ground', 'Vadodara', 1000),
('Community Hall', 'Surat', 150),
('Open Air Theatre', 'Rajkot', 700);

INSERT INTO Organizers (organizer_name, contact_email, phone_number) VALUES
('Bright Events', 'bright@example.com', '9876500001'),
('Future Planners', 'future@example.com', '9876500002'),
('Creative Team', 'creative@example.com', '9876500003'),
('NextGen Events', 'nextgen@example.com', '9876500004');

INSERT INTO Attendees (name, email, phone_number) VALUES
('Aarav Shah', 'aarav@example.com', '9000000001'),
('Diya Patel', 'diya@example.com', '9000000002'),
('Rohan Mehta', 'rohan@example.com', '9000000003'),
('Meera Joshi', NULL, '9000000004'),
('Kabir Desai', 'kabir@example.com', '9000000005'),
('Anaya Shah', 'anaya@example.com', '9000000006'),
('Ishaan Dave', 'ishaan@example.com', '9000000007'),
('Priya Trivedi', 'priya@example.com', '9000000008');

INSERT INTO Events
(event_name, event_date, venue_id, organizer_id, ticket_price, total_seats, available_seats) VALUES
('New Year Music Night', '2026-12-20 18:00:00', 1, 1, 800.00, 500, 300),
('Data & AI Workshop', '2026-11-10 10:00:00', 2, 2, 1200.00, 300, 100),
('Winter Food Festival', '2026-12-12 16:00:00', 4, 1, 250.00, 150, 100),
('City Marathon', '2026-10-25 06:00:00', 3, 3, 500.00, 1000, 600),
('Business Networking Meet', '2026-11-22 17:00:00', 5, 4, 1500.00, 700, 500),
('Photography Walk', '2027-01-15 07:00:00', 4, 2, 300.00, 150, 150),
('Community Coding Day', '2026-12-05 09:00:00', 2, 3, 600.00, 300, 280);

INSERT INTO Tickets (event_id, attendee_id, booking_date, status) VALUES
(1, 1, NOW() - INTERVAL 2 DAY, 'Confirmed'),
(1, 2, NOW() - INTERVAL 1 DAY, 'Confirmed'),
(1, 3, NOW() - INTERVAL 5 DAY, 'Confirmed'),
(2, 1, NOW() - INTERVAL 3 DAY, 'Confirmed'),
(2, 4, NOW() - INTERVAL 1 DAY, 'Pending'),
(3, 5, NOW() - INTERVAL 2 DAY, 'Confirmed'),
(3, 6, NOW() - INTERVAL 10 DAY, 'Confirmed'),
(4, 2, NOW() - INTERVAL 4 DAY, 'Confirmed'),
(4, 7, NOW() - INTERVAL 8 DAY, 'Pending'),
(5, 3, NOW() - INTERVAL 6 DAY, 'Confirmed'),
(5, 5, NOW() - INTERVAL 2 DAY, 'Cancelled'),
(7, 8, NOW() - INTERVAL 1 DAY, 'Pending');

INSERT INTO Payments (ticket_id, amount_paid, payment_status, payment_date) VALUES
(1, 800.00, 'Success', NOW() - INTERVAL 2 DAY),
(2, 800.00, 'Success', NOW() - INTERVAL 1 DAY),
(3, 800.00, 'Success', NOW() - INTERVAL 5 DAY),
(4, 1200.00, 'Success', NOW() - INTERVAL 3 DAY),
(5, 1200.00, 'Pending', NULL),
(6, 250.00, 'Success', NOW() - INTERVAL 2 DAY),
(7, 250.00, 'Success', NOW() - INTERVAL 10 DAY),
(8, 500.00, 'Success', NOW() - INTERVAL 4 DAY),
(9, 500.00, 'Failed', NOW() - INTERVAL 8 DAY),
(10, 1500.00, 'Success', NOW() - INTERVAL 6 DAY),
(11, 1500.00, 'Failed', NOW() - INTERVAL 2 DAY),
(12, 600.00, 'Pending', NULL);

-- =========================================================
-- A. CRUD OPERATIONS
-- Run these examples individually when testing updates/deletes,
-- because they change the sample data.
-- =========================================================

-- CREATE / INSERT example:
-- INSERT INTO Venues (venue_name, location, capacity)
-- VALUES ('New Test Venue', 'Surat', 200);

-- READ / SEARCH:
SELECT * FROM Events WHERE event_name LIKE '%Music%';

-- UPDATE example:
-- UPDATE Events SET ticket_price = 850.00 WHERE event_id = 1;

-- DELETE example (delete dependent rows first if required):
-- DELETE FROM Payments WHERE ticket_id = 12;
-- DELETE FROM Tickets WHERE ticket_id = 12;

-- =========================================================
-- B. WHERE, HAVING, LIMIT
-- =========================================================

-- Upcoming events in a specific city (change Surat as required).
SELECT e.event_id, e.event_name, e.event_date, v.location
FROM Events e
JOIN Venues v ON e.venue_id = v.venue_id
WHERE v.location = 'Surat' AND e.event_date >= NOW()
ORDER BY e.event_date;

-- Top 5 highest revenue-generating events (successful payments only).
SELECT e.event_id, e.event_name, SUM(p.amount_paid) AS total_revenue
FROM Events e
JOIN Tickets t ON t.event_id = e.event_id
JOIN Payments p ON p.ticket_id = t.ticket_id
WHERE p.payment_status = 'Success' AND t.status = 'Confirmed'
GROUP BY e.event_id, e.event_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Attendees who booked tickets in the last 7 days.
SELECT DISTINCT a.attendee_id, a.name, t.booking_date
FROM Attendees a
JOIN Tickets t ON t.attendee_id = a.attendee_id
WHERE t.booking_date >= NOW() - INTERVAL 7 DAY
ORDER BY t.booking_date DESC;

-- =========================================================
-- C. AND, OR, NOT
-- =========================================================

-- Events in December with more than 50% seats available.
SELECT event_id, event_name, event_date, available_seats, total_seats
FROM Events
WHERE MONTH(event_date) = 12
  AND available_seats > total_seats * 0.50;

-- Attendees who booked a ticket OR have a pending payment.
SELECT DISTINCT a.attendee_id, a.name
FROM Attendees a
LEFT JOIN Tickets t ON t.attendee_id = a.attendee_id
LEFT JOIN Payments p ON p.ticket_id = t.ticket_id
WHERE t.ticket_id IS NOT NULL OR p.payment_status = 'Pending';

-- Events that are NOT fully booked.
SELECT event_id, event_name, total_seats, available_seats
FROM Events
WHERE NOT (available_seats = 0);

-- =========================================================
-- D. ORDER BY, GROUP BY
-- =========================================================

-- Sort events by date ascending.
SELECT event_id, event_name, event_date
FROM Events
ORDER BY event_date ASC;

-- Number of attendees per event.
SELECT e.event_id, e.event_name, COUNT(t.ticket_id) AS attendee_count
FROM Events e
LEFT JOIN Tickets t ON t.event_id = e.event_id AND t.status <> 'Cancelled'
GROUP BY e.event_id, e.event_name
ORDER BY attendee_count DESC;

-- Total successful revenue generated per event.
SELECT e.event_id, e.event_name,
       COALESCE(SUM(CASE WHEN p.payment_status = 'Success' THEN p.amount_paid ELSE 0 END), 0) AS total_revenue
FROM Events e
LEFT JOIN Tickets t ON t.event_id = e.event_id
LEFT JOIN Payments p ON p.ticket_id = t.ticket_id
GROUP BY e.event_id, e.event_name
ORDER BY total_revenue DESC;

-- =========================================================
-- E. AGGREGATE FUNCTIONS
-- =========================================================

-- Total revenue from successful payments.
SELECT SUM(amount_paid) AS total_revenue
FROM Payments
WHERE payment_status = 'Success';

-- Event with highest attendee count.
SELECT e.event_id, e.event_name, COUNT(t.ticket_id) AS attendee_count
FROM Events e
LEFT JOIN Tickets t ON t.event_id = e.event_id AND t.status <> 'Cancelled'
GROUP BY e.event_id, e.event_name
ORDER BY attendee_count DESC
LIMIT 1;

-- Average ticket price across all events.
SELECT AVG(ticket_price) AS average_ticket_price FROM Events;

-- Also demonstrate MAX, MIN, COUNT.
SELECT MAX(ticket_price) AS highest_ticket_price,
       MIN(ticket_price) AS lowest_ticket_price,
       COUNT(*) AS total_events
FROM Events;

-- =========================================================
-- F. PRIMARY / FOREIGN KEY CHECKS
-- =========================================================

-- Unique constraint uq_attendee_event prevents duplicate bookings
-- for the same attendee and event. This query can be used to inspect:
SELECT attendee_id, event_id, COUNT(*) AS booking_count
FROM Tickets
GROUP BY attendee_id, event_id
HAVING COUNT(*) > 1;

-- Payments.ticket_id is a foreign key referencing Tickets.ticket_id.
SELECT p.payment_id, p.ticket_id, t.event_id, t.attendee_id,
       p.amount_paid, p.payment_status
FROM Payments p
JOIN Tickets t ON p.ticket_id = t.ticket_id;

-- =========================================================
-- G. JOINS
-- =========================================================

-- INNER JOIN: event details and venue information.
SELECT e.event_name, e.event_date, v.venue_name, v.location, v.capacity
FROM Events e
INNER JOIN Venues v ON e.venue_id = v.venue_id;

-- LEFT JOIN: attendees who booked a ticket but have not completed payment.
SELECT a.name, e.event_name, t.ticket_id, p.payment_status
FROM Attendees a
JOIN Tickets t ON t.attendee_id = a.attendee_id
JOIN Events e ON e.event_id = t.event_id
LEFT JOIN Payments p ON p.ticket_id = t.ticket_id
WHERE p.payment_id IS NULL OR p.payment_status <> 'Success';

-- RIGHT JOIN: events without any attendees.
SELECT e.event_id, e.event_name, t.ticket_id
FROM Tickets t
RIGHT JOIN Events e ON e.event_id = t.event_id
WHERE t.ticket_id IS NULL;

-- FULL OUTER JOIN equivalent in MySQL: combine LEFT and RIGHT JOIN.
-- UNION removes duplicate rows; UNION ALL could be used with careful filtering.
SELECT a.attendee_id, a.name, t.ticket_id
FROM Attendees a
LEFT JOIN Tickets t ON t.attendee_id = a.attendee_id
UNION
SELECT a.attendee_id, a.name, t.ticket_id
FROM Attendees a
RIGHT JOIN Tickets t ON t.attendee_id = a.attendee_id;

-- Attendees who have not booked any ticket.
SELECT a.attendee_id, a.name
FROM Attendees a
LEFT JOIN Tickets t ON t.attendee_id = a.attendee_id
WHERE t.ticket_id IS NULL;

-- =========================================================
-- H. SUBQUERIES
-- =========================================================

-- Events whose successful revenue is above average event revenue.
SELECT revenue_by_event.event_id, revenue_by_event.event_name, revenue_by_event.total_revenue
FROM (
    SELECT e.event_id, e.event_name,
           COALESCE(SUM(CASE WHEN p.payment_status = 'Success' THEN p.amount_paid ELSE 0 END), 0) AS total_revenue
    FROM Events e
    LEFT JOIN Tickets t ON t.event_id = e.event_id
    LEFT JOIN Payments p ON p.ticket_id = t.ticket_id
    GROUP BY e.event_id, e.event_name
) AS revenue_by_event
WHERE revenue_by_event.total_revenue > (
    SELECT AVG(event_revenue)
    FROM (
        SELECT e2.event_id,
               COALESCE(SUM(CASE WHEN p2.payment_status = 'Success' THEN p2.amount_paid ELSE 0 END), 0) AS event_revenue
        FROM Events e2
        LEFT JOIN Tickets t2 ON t2.event_id = e2.event_id
        LEFT JOIN Payments p2 ON p2.ticket_id = t2.ticket_id
        GROUP BY e2.event_id
    ) AS average_revenue
);

-- Attendees who have booked tickets for multiple events.
SELECT a.attendee_id, a.name, COUNT(DISTINCT t.event_id) AS event_count
FROM Attendees a
JOIN Tickets t ON t.attendee_id = a.attendee_id
GROUP BY a.attendee_id, a.name
HAVING COUNT(DISTINCT t.event_id) > 1;

-- Organizers who have managed more than 3 events.
SELECT o.organizer_id, o.organizer_name, COUNT(e.event_id) AS events_managed
FROM Organizers o
JOIN Events e ON e.organizer_id = o.organizer_id
GROUP BY o.organizer_id, o.organizer_name
HAVING COUNT(e.event_id) > 3;

-- =========================================================
-- I. DATE & TIME FUNCTIONS
-- =========================================================

-- Extract month from event date.
SELECT event_name, event_date, MONTH(event_date) AS event_month
FROM Events;

-- Days remaining until each upcoming event.
SELECT event_name, event_date,
       DATEDIFF(DATE(event_date), CURDATE()) AS days_remaining
FROM Events
WHERE DATE(event_date) >= CURDATE()
ORDER BY event_date;

-- Format payment_date as YYYY-MM-DD HH:MM:SS.
SELECT payment_id, DATE_FORMAT(payment_date, '%Y-%m-%d %H:%i:%s') AS formatted_payment_date
FROM Payments;

-- =========================================================
-- J. STRING FUNCTIONS
-- =========================================================

-- Convert organizer names to uppercase.
SELECT organizer_id, UPPER(organizer_name) AS organizer_name_upper
FROM Organizers;

-- Remove extra leading/trailing spaces from attendee names.
SELECT attendee_id, TRIM(name) AS clean_name
FROM Attendees;

-- Replace NULL emails with 'Not Provided'.
SELECT attendee_id, name, COALESCE(email, 'Not Provided') AS email
FROM Attendees;

-- =========================================================
-- K. WINDOW FUNCTIONS (MySQL 8.0+)
-- =========================================================

-- Rank events by total successful revenue.
WITH EventRevenue AS (
    SELECT e.event_id, e.event_name,
           COALESCE(SUM(CASE WHEN p.payment_status = 'Success' THEN p.amount_paid ELSE 0 END), 0) AS total_revenue
    FROM Events e
    LEFT JOIN Tickets t ON t.event_id = e.event_id
    LEFT JOIN Payments p ON p.ticket_id = t.ticket_id
    GROUP BY e.event_id, e.event_name
)
SELECT event_id, event_name, total_revenue,
       RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM EventRevenue;

-- Cumulative sum of successful ticket sales by payment date.
SELECT payment_id, payment_date, amount_paid,
       SUM(amount_paid) OVER (
           ORDER BY payment_date, payment_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS cumulative_ticket_sales
FROM Payments
WHERE payment_status = 'Success'
ORDER BY payment_date, payment_id;

-- Running total of attendees registered per event ordered by event date.
SELECT e.event_id, e.event_name, e.event_date,
       COUNT(t.ticket_id) AS event_attendees,
       SUM(COUNT(t.ticket_id)) OVER (
           ORDER BY e.event_date
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total_attendees
FROM Events e
LEFT JOIN Tickets t ON t.event_id = e.event_id AND t.status <> 'Cancelled'
GROUP BY e.event_id, e.event_name, e.event_date
ORDER BY e.event_date;

-- =========================================================
-- L. CASE EXPRESSIONS
-- =========================================================

-- Categorize demand by seats remaining.
SELECT event_id, event_name, available_seats, total_seats,
       CASE
           WHEN available_seats < total_seats * 0.20 THEN 'High Demand'
           WHEN available_seats BETWEEN total_seats * 0.20 AND total_seats * 0.50 THEN 'Moderate Demand'
           ELSE 'Low Demand'
       END AS demand_level
FROM Events;

-- Categorize payment statuses.
SELECT payment_id, ticket_id, payment_status,
       CASE
           WHEN payment_status = 'Success' THEN 'Successful'
           WHEN payment_status = 'Failed' THEN 'Failed'
           ELSE 'Pending'
       END AS payment_status_label
FROM Payments;
