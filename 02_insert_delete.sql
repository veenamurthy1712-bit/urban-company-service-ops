-- (a) Remove the 3 dummy/test rows seeded by the generator.
DELETE FROM bookings WHERE is_test = 1;

-- (b) Insert the 3 replacement bookings.
-- generate_data.py computes status and customer_rating only to keep the
-- random sequence stable, and it does not store those two fields.
-- bookings has 9 columns, so the insert below keeps the brief's ids,
-- partners, cities, categories, date, and amounts (3200, 640, 980)
-- and sets complaint_flag, sla_breach_flag, is_test to 0.
INSERT INTO bookings (
    booking_id, partner_id, city, category, booking_date,
    amount_inr, complaint_flag, sla_breach_flag, is_test
) VALUES
    ('B9001', 'P009', 'Mumbai', 'Deep Home Cleaning', '2026-03-31', 3200, 0, 0, 0),
    ('B9002', 'P041', 'Chennai', 'Plumbing', '2026-03-31', 640, 0, 0, 0),
    ('B9003', 'P035', 'Hyderabad', 'Electrical Repair', '2026-03-31', 980, 0, 0, 0);

-- SELECT COUNT(*), SUM(amount_inr) FROM bookings;
-- 600 rows, 1047973 (₹10,47,973)

-- Partners whose primary category starts with Salon.
-- Expected: 12 partners.
SELECT partner_id, city, primary_category, rating
FROM partners
WHERE primary_category LIKE 'Salon%'
ORDER BY partner_id;

-- Task 8 export. This result set is written, unmodified, to city_category_summary.csv.
SELECT city, category,
       COUNT(*) AS bookings_count,
       SUM(amount_inr) AS revenue_inr,
       SUM(sla_breach_flag) AS sla_breaches
FROM bookings
GROUP BY city, category
ORDER BY city, category;
