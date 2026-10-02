-- (a) Exact-duplicate partner ids in the raw import.
-- Expected: P003, P017, P031, each with duplicate_rows = 2.
SELECT partner_id, COUNT(*) AS duplicate_rows
FROM partners_import
GROUP BY partner_id
HAVING COUNT(*) > 1;

-- (b) Clean partners table. Grouping on every column collapses each
-- exact-duplicate pair into one row and keeps every distinct partner.
-- Expected row count: 49.
CREATE TABLE partners AS
SELECT partner_id, city, primary_category, rating, active, days_since_onboarding
FROM partners_import
GROUP BY partner_id, city, primary_category, rating, active, days_since_onboarding;

-- 5(a) Every booking resolves to a real partner.
SELECT COUNT(*) AS booking_rows, COUNT(p.partner_id) AS matched_partner_rows
FROM bookings b
INNER JOIN partners p ON b.partner_id = p.partner_id;

-- 5(b) Category that has never received a booking.
-- Expected: Pest Control only.
SELECT c.category
FROM categories c
LEFT JOIN bookings b ON c.category = b.category
WHERE b.booking_id IS NULL;

-- 5(c) Partner who has never received a booking.
-- Expected: P049 only.
SELECT p.partner_id, p.city, p.primary_category
FROM partners p
LEFT JOIN bookings b ON p.partner_id = b.partner_id
WHERE b.booking_id IS NULL;

-- 5(d) COUNT(*) counts the joined row itself, including the all-NULL unmatched
-- row, while COUNT(b.booking_id) counts only rows where a real booking matched.
-- Pest Control is therefore COUNT(*) = 1 and COUNT(b.booking_id) = 0;
-- every other category shows the two counts equal.
SELECT c.category,
       COUNT(*) AS joined_row_count,
       COUNT(b.booking_id) AS matched_booking_count
FROM categories c
LEFT JOIN bookings b ON c.category = b.category
GROUP BY c.category
ORDER BY c.category;
