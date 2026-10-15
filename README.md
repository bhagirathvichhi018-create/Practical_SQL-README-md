# Smart Event Management System (MySQL)

## Project overview
This beginner-friendly SQL project models an event management system. Organizers can manage events and venues, attendees can book tickets, payments can be tracked, and reports can be generated.

## Requirements
- MySQL 8.0 or newer (window functions and CTEs are used).
- MySQL Workbench or MySQL command line.

## Files
- `event_management.sql` — creates the database and six related tables, inserts sample records, and contains queries for every assignment task.

## Database schema
1. **Venues** (`venue_id` PK): venue name, city/location, capacity.
2. **Organizers** (`organizer_id` PK): organizer name and contact details.
3. **Attendees** (`attendee_id` PK): attendee name and contact details.
4. **Events** (`event_id` PK): event date, venue FK, organizer FK, ticket price, total seats, available seats.
5. **Tickets** (`ticket_id` PK): event FK, attendee FK, booking date and status. `UNIQUE(attendee_id, event_id)` prevents the same attendee from booking the same event more than once.
6. **Payments** (`payment_id` PK): ticket FK, amount, payment status and payment date.

## Relationships
- One venue can host many events.
- One organizer can manage many events.
- One attendee can book tickets for multiple events.
- One event can have many tickets.
- A ticket can have payment records associated with it.
- Foreign keys preserve valid relationships between tables.

## How to run in MySQL Workbench
1. Open MySQL Workbench and connect to your local MySQL server.
2. Choose **File → Open SQL Script** and open `event_management.sql`.
3. Click the lightning-bolt **Execute** button to run the script.
4. The script creates and selects `smart_event_db`, creates tables, inserts sample data, then runs example queries.
5. To see tables, expand **Schemas → smart_event_db → Tables** and refresh if needed.

> Important: the script drops and recreates the six project tables each time it runs. Do not run it against a database containing data you need to keep.

## Included assignment topics
- CRUD examples for events, venues, organizers, attendees and tickets.
- `WHERE`, `HAVING`, `LIMIT`, `AND`, `OR`, `NOT`.
- `ORDER BY`, `GROUP BY`, `SUM`, `AVG`, `MAX`, `MIN`, `COUNT`.
- Primary keys, foreign keys and duplicate-booking prevention.
- `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, and a `UNION`-based full-outer-join equivalent (MySQL does not directly support `FULL OUTER JOIN`).
- Subqueries, date/time functions, string functions, window functions, and `CASE`.
- Sample data that makes the reporting queries useful to test.

## Notes
- Some sample event dates are in the past and some are in the future so date queries can be demonstrated.
- The seat counts are sample values. This SQL script does not automatically decrement `available_seats` when a ticket is booked; that would require application logic or triggers and is beyond the current assignment scope.
# Practical_SQL-README-md
