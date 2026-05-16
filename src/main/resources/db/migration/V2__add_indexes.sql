-- ══════════════════════════════════════════════════════
--  V2__add_indexes.sql
--  Adds indexes for all columns used in WHERE clauses,
--  JOIN conditions, and ORDER BY.
--  Separate from V1 so index strategy can evolve independently.
-- ══════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────
--  books indexes
--  isbn already indexed via UNIQUE constraint in V1.
-- ──────────────────────────────────────────────────────

-- Search by title (LIKE 'Clean%' queries)
CREATE INDEX idx_books_title
    ON books (title);

-- Search by author
CREATE INDEX idx_books_author
    ON books (author);

-- Filter by category
CREATE INDEX idx_books_category
    ON books (category);

-- Soft delete filter — most queries add WHERE deleted_at IS NULL
CREATE INDEX idx_books_deleted_at
    ON books (deleted_at);

-- ──────────────────────────────────────────────────────
--  members indexes
--  email already indexed via UNIQUE constraint in V1.
-- ──────────────────────────────────────────────────────

-- Filter active/inactive members
CREATE INDEX idx_members_status
    ON members (status);

-- ──────────────────────────────────────────────────────
--  book_transactions indexes
-- ──────────────────────────────────────────────────────

-- "Show all transactions for this member" — most common query
CREATE INDEX idx_bt_member_id
    ON book_transactions (member_id);

-- "Show all transactions for this book"
CREATE INDEX idx_bt_book_id
    ON book_transactions (book_id);

-- Filter by status (ISSUED / RETURNED / OVERDUE)
CREATE INDEX idx_bt_status
    ON book_transactions (status);

-- Business rule check: "has this member already issued this book?"
-- Composite index — covers both columns in one lookup
CREATE INDEX idx_bt_member_book
    ON book_transactions (member_id, book_id);

-- Overdue job: find all ISSUED records past due_date
CREATE INDEX idx_bt_due_date
    ON book_transactions (due_date);