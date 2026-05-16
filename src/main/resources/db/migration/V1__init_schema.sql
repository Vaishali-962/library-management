-- ══════════════════════════════════════════════════════
--  V1__init_schema.sql
--  Creates all core tables for the Library Management System.
--  Flyway runs this exactly once and tracks it in flyway_schema_history.
-- ══════════════════════════════════════════════════════

-- ──────────────────────────────────────────────────────
--  TABLE: books
-- ──────────────────────────────────────────────────────
CREATE TABLE books (
                       id               BIGINT          NOT NULL AUTO_INCREMENT,
                       title            VARCHAR(255)    NOT NULL,
                       author           VARCHAR(255)    NOT NULL,
                       isbn             VARCHAR(20)     NOT NULL,
                       category         VARCHAR(100),
                       total_copies     INT             NOT NULL DEFAULT 0,
                       available_copies INT             NOT NULL DEFAULT 0,
                       shelf_location   VARCHAR(100),

    -- Soft delete: deleted_at is NULL means active, non-NULL means deleted
                       deleted_at       DATETIME,

                       created_at       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

                       CONSTRAINT pk_books          PRIMARY KEY (id),
                       CONSTRAINT uq_books_isbn     UNIQUE (isbn),

    -- Business rule: copies cannot be negative
                       CONSTRAINT chk_total_copies     CHECK (total_copies >= 0),
                       CONSTRAINT chk_available_copies CHECK (available_copies >= 0),
                       CONSTRAINT chk_available_lte_total CHECK (available_copies <= total_copies)
);

-- ──────────────────────────────────────────────────────
--  TABLE: members
-- ──────────────────────────────────────────────────────
CREATE TABLE members (
                         id         BIGINT       NOT NULL AUTO_INCREMENT,
                         name       VARCHAR(255) NOT NULL,
                         email      VARCHAR(255) NOT NULL,
                         phone      VARCHAR(20),
                         status     VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE',   -- ACTIVE | INACTIVE

                         created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
                         updated_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

                         CONSTRAINT pk_members       PRIMARY KEY (id),
                         CONSTRAINT uq_members_email UNIQUE (email),
                         CONSTRAINT chk_member_status CHECK (status IN ('ACTIVE', 'INACTIVE'))
);

-- ──────────────────────────────────────────────────────
--  TABLE: book_transactions
--  One row per issue event. Never updated for history —
--  only returnedAt, status, and fineAmount are updated on return.
-- ──────────────────────────────────────────────────────
CREATE TABLE book_transactions (
                                   id           BIGINT          NOT NULL AUTO_INCREMENT,

    -- Foreign keys
                                   book_id      BIGINT          NOT NULL,
                                   member_id    BIGINT          NOT NULL,

    -- Timestamps
                                   issued_at    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   due_date     DATETIME        NOT NULL,
                                   returned_at  DATETIME,                                -- NULL until returned

    -- Status: ISSUED | RETURNED | OVERDUE
                                   status       VARCHAR(20)     NOT NULL DEFAULT 'ISSUED',

    -- Bonus: overdue fine (calculated on return)
                                   fine_amount  DECIMAL(10, 2)  NOT NULL DEFAULT 0.00,

                                   created_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   updated_at   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

                                   CONSTRAINT pk_book_transactions  PRIMARY KEY (id),
                                   CONSTRAINT fk_bt_book            FOREIGN KEY (book_id)   REFERENCES books(id),
                                   CONSTRAINT fk_bt_member          FOREIGN KEY (member_id) REFERENCES members(id),
                                   CONSTRAINT chk_transaction_status CHECK (status IN ('ISSUED', 'RETURNED', 'OVERDUE')),
                                   CONSTRAINT chk_fine_amount        CHECK (fine_amount >= 0)
);