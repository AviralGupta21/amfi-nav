/*
003_securities.sql
ISIN-level identifiers, mapping each security to its scheme.

Source: historical NAV archive (SQLite), securities table.

One scheme can have several ISINs. AMFI publishes separate identifiers for
payout and reinvestment variants of the same scheme, so the relationship
here is many-to-one against schemes.

isin is the primary key. Checked against the source: no nulls, no blanks.

type is stored as published. Its values are undocumented and have not been
interpreted, so no constraint is asserted on it. It may encode the
payout/reinvestment distinction, but that is untested.

Depends on core.schemes.
*/

CREATE TABLE core.securities
(
    isin TEXT,
    type INTEGER,
    scheme_code INTEGER NOT NULL REFERENCES core.schemes(scheme_code),
    CONSTRAINT pk_securities PRIMARY KEY (isin)
);
COMMENT ON COLUMN core.securities.type IS 'Undocumented in source; Value not yet interpreted';