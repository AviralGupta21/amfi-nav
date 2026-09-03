/*
006_stage_stress_test.sql
Landing table for AMFI's monthly stress test disclosures. Six CSVs, one per
month February to July 2024, produced by scripts/convert_stress_test.py.

EVERY COLUMN IS TEXT
    \copy rejects the entire file if a single cell will not cast, so nothing
    is typed here. Casting happens on the way into core.stress_test, where a
    bad value can be found and dealt with rather than blocking the load.

    The source data justifies the caution. One AMC filed percentage fields
    as fractions for two months; five reported zero standard deviation and
    zero beta, which is impossible for an equity fund and means the metric
    was not supplied.

NO CONSTRAINTS, NO PRIMARY KEY
    This is a landing zone, truncated and refilled on every run. The
    constraints live in core.stress_test, which is where they belong: they
    should reject bad data at the point it enters the real table, not
    prevent it from being landed and inspected.

file_date_label IS DELIBERATELY UNUSED
    The source files carry a date column reading 01-Feb-2024, 01-Mar-2024
    and so on - a month label, not a portfolio date. The disclosures are
    published by the 15th based on the preceding month, and the AUM series
    matches month-end figures reported independently. as_of_month is
    therefore derived from the filename by the conversion script, and
    core.stress_test records as_of_source = 'file_name'.

    The column is landed anyway, so that what was in the file is visible
    rather than silently discarded.

COLUMN ORDER MATCHES THE CSV EXACTLY
    Eighteen columns from the source file, then two added by the conversion
    script. \copy maps by position, not by name, so this order is load
    bearing - a column inserted or reordered here misaligns every row
    without raising an error.

Names match core.stress_test wherever the columns correspond, so the insert
from staging reads as a cast rather than a translation.
*/

CREATE TABLE staging.stress_test_raw 
(
    file_date_label TEXT,
    raw_scheme_name TEXT,
    aum_cr TEXT,
    days_to_liquidate_50pct TEXT,
    days_to_liquidate_25pct TEXT,
    top10_investor_pct TEXT,
    large_cap_pct TEXT,
    mid_cap_pct TEXT,
    small_cap_pct TEXT,
    cash_pct TEXT,
    portfolio_std_dev_pct TEXT,
    benchmark_std_dev_pct TEXT,
    portfolio_beta TEXT,
    portfolio_trailing_pe TEXT,
    benchmark_pe_trailing_12m TEXT,
    benchmark_pe_1y_ago TEXT,
    benchmark_pe_2y_ago TEXT,
    portfolio_turnover_ratio TEXT,
    source_file TEXT,
    as_of_month TEXT
);