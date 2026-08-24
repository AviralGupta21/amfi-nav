-- 002_load_core.sql
-- Bulk loads the NAV archive into core.
--
-- RUN FROM THE PROJECT ROOT. Paths are relative to psql's working
-- directory, not to this file's location.
--
-- Uses \copy rather than COPY. The Postgres Windows service runs as
-- NT AUTHORITY\NetworkService and cannot read user folders; \copy is
-- client-side and reads the file as the invoking user.
--
-- Order is forced by foreign keys: schemes must exist before securities
-- and nav can reference it.
--
-- Column lists are mandatory. The source columns are date and nav; the
-- target columns are nav_date and nav_value. HEADER true discards the
-- header row and maps the remainder positionally into the named columns,
-- so the names differing is fine as long as the order matches.
--
-- nav is loaded as a slice from 2022-01-01 onward, filtered at export
-- time in SQLite. The full history is not loaded here.
--
-- Expected counts: schemes 38,107. nav 8,931,779.
--
-- Indexes are NOT created here. Run 008_indexes.sql afterwards.
--
-- This file contains psql backslash commands, so it only runs via \i or
-- psql -f. It will not work through pgAdmin or a SQL extension.

\copy core.schemes(scheme_code, scheme_name) FROM 'data/schemes.csv' WITH (FORMAT csv, HEADER true)
\copy core.securities(isin, type, scheme_code) FROM 'data/securities.csv' WITH (FORMAT csv, HEADER true)
\copy core.nav(scheme_code, nav_date, nav_value) FROM 'data/nav.csv' WITH (FORMAT csv, HEADER true)