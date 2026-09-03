/*
011_amfi_scheme_alias.sql
Maps the scheme names AMFI uses in its stress test disclosures to the fund
house slugs in core.study_universe.

WHY A TABLE AND NOT A CASE EXPRESSION
    It does two jobs. Joining core.stress_test through this table resolves
    the name AND filters the universe in one step: AMFI's files carry 28
    schemes, four of which - LIC MF, Motilal Oswal, Quantum and JM - are
    outside the study. They have no rows here, so an inner join drops them
    without a maintained exclusion list.

    It is also inspectable. Twenty-four rows of mapping are readable in a
    way that a twenty-four branch CASE buried in an insert is not.

THE NAMES DO NOT MATCH THE NAV ARCHIVE
    AMFI writes the scheme name differently from the archive that supplies
    the NAV series, so this table cannot be derived from study_universe and
    has to be maintained separately. Three cases matter:

    Franklin India Smaller Companies Fund
        The archive calls the same fund Franklin India Small Cap Fund. It
        was renamed after the March 2024 filings examined in this project
        and the archive carries the newer name against the original code.

    Kotak Small Cap Fund
        The archive writes Kotak-Small Cap Fund, hyphenated, with no space.

    ICICI Prudential Smallcap Fund, Invesco India Smallcap Fund
        One word here, and in the archive. Other fund houses use two.

\u26a0 QUANT AND QUANTUM ARE DIFFERENT FUND HOUSES
    Quant Small Cap Fund maps to quant and is in the universe. QUANTUM SMALL
    CAP FUND is a different AMC and is deliberately absent. The two sit on
    adjacent rows in every source file, and confusing them would attribute a
    fund of roughly 39 crore to one of roughly 17,000.

CONSTRAINTS
    raw_scheme_name is the primary key: one AMFI name resolves to one fund
    house. amc is unique: each fund house in the universe appears under
    exactly one AMFI name. Without the second, two names could both resolve
    to the same fund and silently double its readings in every month.
*/

CREATE TABLE core.amfi_scheme_alias
(
    raw_scheme_name TEXT NOT NULL,
    amc TEXT NOT NULL REFERENCES core.study_universe(amc),
    CONSTRAINT pk_amfi_scheme_alias PRIMARY KEY (raw_scheme_name),
    CONSTRAINT uq_amfi_scheme_alias UNIQUE (amc)
);