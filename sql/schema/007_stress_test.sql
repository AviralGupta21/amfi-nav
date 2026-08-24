/*
007_stress_test.sql
Liquidity stress test and risk parameter disclosures published by AMCs.

Source: per-AMC .xls files, monthly from February 2024. Mandated by SEBI
via AMFI following the February 2024 letters, covering mid and small cap
schemes only.

No natural key exists. The AMFI scheme code appears only in the February
files; every later month dropped it. So identity is a surrogate id, with a
unique constraint on the combination that should occur once: one AMC, one
scheme, one reporting date.

raw_scheme_name is stored exactly as it appeared and is never normalised.
resolved_scheme_code is nullable because most months require resolving the
scheme by name, and some will not resolve. A null there means unresolved,
not absent.

as_of_source records whether the reporting date was read from a column
inside the file or inferred from the filename. February states it; later
months do not. The distinction matters when the two disagree.

Measures are nullable. The source formats vary by AMC and by month, and a
blank cell in one file should not reject an otherwise valid row.

CHECK constraints reject only the structurally impossible: negative AUM,
percentages outside 0 to 100, non-positive dispersion. P/E is deliberately
unconstrained, since a portfolio whose holdings have net negative aggregate
earnings reports a negative P/E, which is arithmetically correct.

Allocation percentages are NOT constrained to sum to 100. An AMC may report
buckets this table has no column for, and a file whose allocations do not
sum is a finding worth counting rather than a row worth rejecting. That test
belongs in the analysis queries.

Depends on core.amc and core.schemes.
*/

CREATE TABLE core.stress_test
(
    id BIGSERIAL,
    amc_code TEXT NOT NULL REFERENCES core.amc(amc_code),
    raw_scheme_name TEXT NOT NULL,
    resolved_scheme_code INTEGER REFERENCES core.schemes(scheme_code),
    as_of_date DATE NOT NULL,
    as_of_source TEXT NOT NULL,
    source_file TEXT NOT NULL,
    loaded_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    aum_cr NUMERIC, 
    days_to_liquidate_50pct NUMERIC,
    days_to_liquidate_25pct NUMERIC,
    top10_investor_pct NUMERIC,
    large_cap_pct NUMERIC,
    mid_cap_pct NUMERIC,
    small_cap_pct NUMERIC,
    cash_pct NUMERIC,
    portfolio_std_dev_pct NUMERIC,
    benchmark_std_dev_pct NUMERIC,
    portfolio_beta NUMERIC,
    portfolio_trailing_pe NUMERIC,
    benchmark_pe_trailing_12m NUMERIC,
    benchmark_pe_1y_ago NUMERIC, 
    benchmark_pe_2y_ago NUMERIC,
    portfolio_turnover_ratio NUMERIC,
    CONSTRAINT pk_stress_test PRIMARY KEY (id),
    CONSTRAINT ck_stress_test_source CHECK (as_of_source IN ('file_column', 'file_name')),
    CONSTRAINT uq_stress_test UNIQUE (as_of_date, amc_code, raw_scheme_name),
    CONSTRAINT ck_st_aum CHECK (aum_cr > 0),
    CONSTRAINT ck_st_liq50 CHECK (days_to_liquidate_50pct >= 0),
    CONSTRAINT ck_st_liq25 CHECK (days_to_liquidate_25pct >= 0),
    CONSTRAINT ck_st_top10 CHECK (top10_investor_pct BETWEEN 0 AND 100),
    CONSTRAINT ck_st_large CHECK (large_cap_pct BETWEEN 0 AND 100),
    CONSTRAINT ck_st_mid CHECK (mid_cap_pct BETWEEN 0 AND 100),
    CONSTRAINT ck_st_small CHECK (small_cap_pct BETWEEN 0 AND 100),
    CONSTRAINT ck_st_cash CHECK (cash_pct BETWEEN 0 AND 100),
    CONSTRAINT ck_st_pstd CHECK (portfolio_std_dev_pct > 0),
    CONSTRAINT ck_st_bstd CHECK (benchmark_std_dev_pct > 0),
    CONSTRAINT ck_st_beta CHECK (portfolio_beta > 0),
    CONSTRAINT ck_st_turnover CHECK (portfolio_turnover_ratio >= 0)
);