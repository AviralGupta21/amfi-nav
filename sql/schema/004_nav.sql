/*
004_nav.sql
Daily NAV per scheme. The fact table.

Source: historical NAV archive (SQLite), nav table.
36,765,864 rows spanning 2006-04-01 to present.

Columns renamed from the source (date, nav) to avoid nav.nav in queries.
The load must therefore name columns explicitly rather than relying on
positional order.

Primary key is (scheme_code, nav_date). Verified against the source: zero
duplicate pairs across all rows, so this is a natural key. It also makes the
load idempotent, since a re-run conflicts rather than duplicating.

nav_value is double precision rather than exact decimal. These values are
used for ratios (returns, drawdowns), not summed as ledger balances, so
accumulated float error is not a concern at this precision.

CHECK (nav_value > 0): a unit price of zero or below would mean the fund's
holdings are worthless. Verified none exist in the source.

Indexes are deliberately absent. They are created after the bulk load.
Note the primary key leads on scheme_code, so it does not serve date-range
scans; a separate index on nav_date is required.

Depends on core.schemes.
*/

CREATE TABLE core.nav
(
    scheme_code INTEGER NOT NULL REFERENCES core.schemes(scheme_code),
    nav_date DATE NOT NULL,
    nav_value DOUBLE PRECISION NOT NULL CHECK (nav_value > 0),
    CONSTRAINT pk_nav PRIMARY KEY (scheme_code, nav_date)
);