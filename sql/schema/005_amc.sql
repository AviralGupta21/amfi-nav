/*
005_amc.sql
Fund house lookup. One row per AMC.

This table is the join key between the stress test disclosures and the
inflow restriction records. Both sources name fund houses as free text, in
inconsistent casing and spelling, so both key on amc_code instead.

The 24 entries were derived from the NAV archive, not copied from a list.
Scheme names were filtered for small-cap markers, excluding index funds,
ETFs, fund-of-funds, closed-ended series and hybrids, then restricted to
schemes with NAV coverage spanning the event: at least one observation on
or before 2024-02-29, one on or after 2024-06-30, and one on or before
2023-02-28 to guarantee twelve months of pre-event history.

Slug convention: lowercase, no spaces or punctuation, derived from the
common short name of the fund house. Recognisable on sight rather than
abbreviated to initials. Where a house is widely known by an acronym
(absl, boi, pgim) that acronym is used.

L&T is deliberately absent. L&T Mutual Fund was acquired by HSBC in 2022
and no longer exists as a fund house. L&T Emerging Businesses Fund
continues as HSBC Small Cap Fund under a different scheme code, so the
relationship is recorded in scheme_lineage rather than here.

Adding an AMC means adding a row to the seed file as well.
*/

CREATE TABLE core.amc
(
    amc_code TEXT, 
    amc_name TEXT NOT NULL,
    disclosures_url TEXT,
    CONSTRAINT pk_amc PRIMARY KEY (amc_code),
    CONSTRAINT ck_amc_code_lower CHECK (amc_code = lower(amc_code)),
    CONSTRAINT ck_amc_code_nospace CHECK (amc_code NOT LIKE '% %'),
    CONSTRAINT uq_amc_name UNIQUE (amc_name)
);