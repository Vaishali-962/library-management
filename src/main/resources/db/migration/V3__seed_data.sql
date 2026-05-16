-- ══════════════════════════════════════════════════════
--  V3__seed_data.sql
--  Sample data for development and demo purposes.
--  Makes the dashboard look real on first run.
-- ══════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────
--  Sample books
-- ──────────────────────────────────────────────────────
INSERT INTO books (title, author, isbn, category, total_copies, available_copies, shelf_location) VALUES
                                                                                                      ('Clean Code',                        'Robert C. Martin',    '9780132350884', 'Software Engineering', 3, 2, 'A-101'),
                                                                                                      ('The Pragmatic Programmer',          'Andrew Hunt',         '9780135957059', 'Software Engineering', 2, 2, 'A-102'),
                                                                                                      ('Spring in Action',                  'Craig Walls',         '9781617294945', 'Java',                 4, 3, 'B-201'),
                                                                                                      ('Head First Java',                   'Kathy Sierra',        '9780596009205', 'Java',                 5, 5, 'B-202'),
                                                                                                      ('Design Patterns',                   'Gang of Four',        '9780201633610', 'Software Engineering', 2, 1, 'A-103'),
                                                                                                      ('Effective Java',                    'Joshua Bloch',        '9780134685991', 'Java',                 3, 3, 'B-203'),
                                                                                                      ('You Don''t Know JS',                'Kyle Simpson',        '9781491904244', 'JavaScript',           2, 2, 'C-301'),
                                                                                                      ('Database Design for Mere Mortals',  'Michael Hernandez',   '9780321884497', 'Database',             1, 1, 'D-401');

-- ──────────────────────────────────────────────────────
--  Sample members
-- ──────────────────────────────────────────────────────
INSERT INTO members (name, email, phone, status) VALUES
                                                     ('Priya Sharma',   'priya.sharma@example.com',   '9876543210', 'ACTIVE'),
                                                     ('Rahul Mehta',    'rahul.mehta@example.com',    '9876543211', 'ACTIVE'),
                                                     ('Anjali Kulkarni','anjali.k@example.com',        '9876543212', 'ACTIVE'),
                                                     ('Dev Patel',      'dev.patel@example.com',       '9876543213', 'ACTIVE'),
                                                     ('Sneha Reddy',    'sneha.reddy@example.com',     '9876543214', 'INACTIVE');

-- ──────────────────────────────────────────────────────
--  Sample transactions
--  issued_at and due_date set manually to create
--  realistic ISSUED / RETURNED / OVERDUE scenarios.
-- ──────────────────────────────────────────────────────
INSERT INTO book_transactions (book_id, member_id, issued_at, due_date, returned_at, status, fine_amount) VALUES
-- Priya issued Clean Code (book 1) — currently ISSUED
(1, 1, '2026-05-10 10:00:00', '2026-05-24 10:00:00', NULL,                  'ISSUED',   0.00),

-- Rahul issued Spring in Action (book 3) — OVERDUE, not returned
(3, 2, '2026-05-01 09:00:00', '2026-05-08 09:00:00', NULL,                  'OVERDUE',  0.00),

-- Anjali issued The Pragmatic Programmer (book 2) — RETURNED
(2, 3, '2026-04-20 11:00:00', '2026-05-04 11:00:00', '2026-05-03 15:00:00','RETURNED',  0.00),

-- Dev issued Design Patterns (book 5) — currently ISSUED
(5, 4, '2026-05-12 14:00:00', '2026-05-26 14:00:00', NULL,                  'ISSUED',   0.00),

-- Sneha issued Head First Java (book 4) — OVERDUE with fine
(4, 5, '2026-04-25 10:00:00', '2026-05-02 10:00:00', NULL,                  'OVERDUE',  0.00);

-- Update available_copies to reflect active issues
-- Clean Code: 3 total, 1 issued → 2 available (already set above)
-- Spring in Action: 4 total, 1 issued → 3 available (already set above)
-- Design Patterns: 2 total, 1 issued → 1 available (already set above)
-- Head First Java: 5 total, 1 issued → 4 available
UPDATE books SET available_copies = 4 WHERE id = 4;