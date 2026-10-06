\c ration_shop;


-- =========================
-- CARD HOLDERS
-- =========================

INSERT INTO card_holder
(card_id, card_number, head_name, address, family_size)
VALUES
(1, 'RC1001', 'Rajesh Sharma', 'Andheri East', 4),
(2, 'RC1002', 'Sunita Patil', 'Borivali West', 5),
(3, 'RC1003', 'Amit Verma', 'Kurla West', 3),
(4, 'RC1004', 'Meena Joshi', 'Dadar East', 7),
(5, 'RC1005', 'Suresh Yadav', 'Ghatkopar East', 6),
(6, 'RC1006', 'Priya Singh', 'Malad West', 2),
(7, 'RC1007', 'Ramesh Gupta', 'Thane West', 8),
(8, 'RC1008', 'Kavita Shah', 'Vikhroli East', 4),
(9, 'RC1009', 'Vijay More', 'Mulund West', 3),
(10, 'RC1010', 'Neha Kulkarni', 'Bhandup West', 5);


-- =========================
-- FAMILY MEMBERS
-- =========================

INSERT INTO family_member
(member_id, card_id, member_name, age, relation)
VALUES
(1, 1, 'Rajesh Sharma', 42, 'Head'),
(2, 1, 'Pooja Sharma', 38, 'Wife'),
(3, 1, 'Aarav Sharma', 14, 'Son'),
(4, 1, 'Anaya Sharma', 10, 'Daughter'),

(5, 2, 'Sunita Patil', 45, 'Head'),
(6, 2, 'Mahesh Patil', 48, 'Husband'),
(7, 2, 'Riya Patil', 18, 'Daughter'),
(8, 2, 'Rohan Patil', 15, 'Son'),
(9, 2, 'Sanjay Patil', 70, 'Father'),

(10, 3, 'Amit Verma', 40, 'Head'),
(11, 3, 'Kiran Verma', 36, 'Wife'),
(12, 3, 'Arjun Verma', 12, 'Son'),

(13, 4, 'Meena Joshi', 50, 'Head'),
(14, 4, 'Rakesh Joshi', 52, 'Husband'),
(15, 4, 'Neel Joshi', 22, 'Son'),
(16, 4, 'Nisha Joshi', 19, 'Daughter'),
(17, 4, 'Asha Joshi', 75, 'Mother'),

(18, 5, 'Suresh Yadav', 44, 'Head'),
(19, 5, 'Rekha Yadav', 40, 'Wife'),
(20, 5, 'Vikas Yadav', 17, 'Son');


-- =========================
-- COMMODITIES
-- =========================

INSERT INTO commodity
(commodity_id, commodity_name, unit, price_per_unit)
VALUES
(1, 'Rice', 'KG', 3.00),
(2, 'Wheat', 'KG', 2.00),
(3, 'Sugar', 'KG', 5.00),
(4, 'Kerosene', 'Litre', 15.00),
(5, 'Dal', 'KG', 20.00);


-- =========================
-- ENTITLEMENTS
-- =========================

INSERT INTO entitlement
(entitlement_id, commodity_id, min_family_size, max_family_size, quantity_allowed)
VALUES
(1, 1, 1, 3, 10.00),
(2, 1, 4, 6, 20.00),
(3, 1, 7, 10, 30.00),

(4, 2, 1, 3, 5.00),
(5, 2, 4, 6, 10.00),
(6, 2, 7, 10, 15.00),

(7, 3, 1, 3, 2.00),
(8, 3, 4, 6, 4.00),
(9, 3, 7, 10, 6.00),

(10, 4, 1, 10, 5.00);


-- =========================
-- STOCK
-- =========================

INSERT INTO stock
(stock_id, commodity_id, quantity_available)
VALUES
(1, 1, 500.00),
(2, 2, 400.00),
(3, 3, 150.00),
(4, 4, 100.00),
(5, 5, 120.00);


-- =========================
-- DISTRIBUTION
-- =========================

INSERT INTO distribution
(distribution_id, card_id, commodity_id, quantity_issued, issue_date)
VALUES
(1, 1, 1, 20.00, '2026-09-01'),
(2, 1, 2, 10.00, '2026-09-01'),
(3, 1, 3, 4.00, '2026-09-01'),

(4, 2, 1, 15.00, '2026-09-02'),
(5, 2, 2, 10.00, '2026-09-02'),
(6, 2, 3, 4.00, '2026-09-02'),

(7, 3, 1, 8.00, '2026-09-03'),
(8, 3, 2, 5.00, '2026-09-03'),

(9, 4, 1, 30.00, '2026-09-04'),
(10, 4, 2, 15.00, '2026-09-04'),
(11, 4, 3, 6.00, '2026-09-04'),

(12, 5, 1, 20.00, '2026-09-05'),
(13, 5, 2, 8.00, '2026-09-05'),

(14, 6, 1, 5.00, '2026-09-06'),
(15, 7, 1, 25.00, '2026-09-07'),
(16, 8, 1, 15.00, '2026-09-08'),
(17, 9, 2, 5.00, '2026-09-09'),
(18, 10, 1, 12.00, '2026-09-10'),
(19, 10, 3, 2.00, '2026-09-10'),
(20, 5, 3, 3.00, '2026-09-11');