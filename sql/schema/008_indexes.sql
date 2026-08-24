/*
008_indexes.sql
Secondary indexes. RUN AFTER THE BULK LOAD, not with the other schema files.

Loading into an indexed table means the index is maintained on every
inserted row. Building afterwards is substantially faster.

Two indexes, both filling gaps the primary keys leave:

nav (nav_date, scheme_code)
    The primary key on nav is (scheme_code, nav_date), leading on
    scheme_code. An index serves only queries that filter on its leading
    column, so the primary key cannot answer date-range scans. Almost every
    query in the event analysis is a date window across many schemes, so
    date leads here. Including scheme_code makes it covering for those
    queries: the index alone satisfies them and the table is never read.

securities (scheme_code)
    The primary key is on isin, so joins from a scheme to its securities
    have nothing to use.

Deliberately absent:

nav (scheme_code)
    Redundant. The primary key already leads on scheme_code.

securities (isin), amc (amc_code), schemes (scheme_code)
    Primary keys create their own indexes.

stress_test
    A few hundred rows fits in one or two pages. A sequential scan beats an
    index traversal at that size and the planner would likely ignore one.
    Index when a query is measurably slow, not when a column looks like a
    join key.
*/

CREATE INDEX IF NOT EXISTS idx_nav_date_scheme ON core.nav(nav_date, scheme_code);
CREATE INDEX IF NOT EXISTS idx_securities_scheme ON core.securities(scheme_code);