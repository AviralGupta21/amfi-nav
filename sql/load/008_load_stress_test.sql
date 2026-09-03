/*
008_load_stress_test.sql
Loads the six months of AMFI stress test disclosures from staging into
core.stress_test. Expect 144 rows: 24 funds by 6 months.

THE JOIN IS THE FILTER
    core.amfi_scheme_alias holds only the 24 fund houses in the study
    universe, so joining through it resolves AMFI's scheme name to a slug
    and drops the four out-of-scope schemes in the same step. There is no
    exclusion list.

    A fund missing from the result therefore means a name mismatch, not an
    empty source file. Verify with the count query below rather than
    assuming.

CASTING HAPPENS HERE, NOT AT COPY
    Staging is entirely text so that \copy cannot reject a file over one bad
    cell. Every value column is cast on the way in, where a failure names
    the column and can be dealt with.

ZERO MEANS NOT REPORTED, FOR THREE COLUMNS ONLY
    NULLIF is applied to portfolio_std_dev_pct, benchmark_std_dev_pct and
    portfolio_beta. Zero volatility and zero beta are impossible for an
    equity fund; five AMCs filed them as placeholders, in several cases
    because the scheme lacked the twelve months of history the metric needs.

    The existing check constraints on those three columns refuse a zero, so
    the load fails without this. That is the constraint working.

    Zeros are left untouched everywhere else. DSP and Tata both report
    large_cap_pct = 0.0 in February, and a small cap fund holding no large
    caps is ordinary.

as_of_source IS SET TO file_name, NOT file_column
    The source files carry a date column, and it is a month label rather
    than a portfolio date. The true reference is month-end, derived from the
    filename by scripts/convert_stress_test.py. The column that exists in
    the file is deliberately not used.

resolved_scheme_code IS LEFT NULL
    Linking each row to its AMFI scheme code in the NAV archive is a
    separate step. core.study_universe already holds the code per fund
    house, so it can be filled by update rather than at load.

Verification:

    SELECT as_of_date, COUNT(*) FROM core.stress_test
    GROUP BY 1 ORDER BY 1;
        Six months, 24 rows each.

    SELECT amc_code, COUNT(*) FROM core.stress_test
    GROUP BY 1 HAVING COUNT(*) <> 6;
        Returns nothing. A fund with fewer than six readings is a name
        mismatch in the alias table.

    SELECT amc_code, as_of_date,
           large_cap_pct + mid_cap_pct + small_cap_pct + cash_pct AS total
    FROM core.stress_test
    WHERE large_cap_pct + mid_cap_pct + small_cap_pct + cash_pct
          NOT BETWEEN 95 AND 105;
        Returns Edelweiss for February and March only, at roughly 1.0. That
        AMC filed percentage fields as fractions for those two months and
        corrected it from April. Expected, and corrected in the analysis
        view rather than here. Any other fund appearing is a real problem.
*/

INSERT INTO core.stress_test (
    amc_code, raw_scheme_name, as_of_date, as_of_source, source_file,
    aum_cr, days_to_liquidate_50pct, days_to_liquidate_25pct,
    top10_investor_pct, large_cap_pct, mid_cap_pct, small_cap_pct, cash_pct,
    portfolio_std_dev_pct, benchmark_std_dev_pct, portfolio_beta,
    portfolio_trailing_pe, benchmark_pe_trailing_12m,
    benchmark_pe_1y_ago, benchmark_pe_2y_ago, portfolio_turnover_ratio
)
SELECT
    a.amc,
    s.raw_scheme_name,
    s.as_of_month::date,
    'file_name',
    s.source_file,
    s.aum_cr::numeric,
    s.days_to_liquidate_50pct::numeric,
    s.days_to_liquidate_25pct::numeric,
    s.top10_investor_pct::numeric,
    s.large_cap_pct::numeric,
    s.mid_cap_pct::numeric,
    s.small_cap_pct::numeric,
    s.cash_pct::numeric,
    NULLIF(s.portfolio_std_dev_pct::numeric, 0),
    NULLIF(s.benchmark_std_dev_pct::numeric, 0),
    NULLIF(s.portfolio_beta::numeric, 0),
    s.portfolio_trailing_pe::numeric,
    s.benchmark_pe_trailing_12m::numeric,
    s.benchmark_pe_1y_ago::numeric,
    s.benchmark_pe_2y_ago::numeric,
    s.portfolio_turnover_ratio::numeric
FROM staging.stress_test_raw s
JOIN core.amfi_scheme_alias a ON s.raw_scheme_name = a.raw_scheme_name;