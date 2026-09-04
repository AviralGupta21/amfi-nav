/*
004_flows_by_fund.sql
Separates investor flows from investment performance in each fund's monthly
AUM change, March to July 2024.

THE DECOMPOSITION
    A fund's AUM moves for two reasons: the portfolio gained or lost value,
    and investors put money in or took it out. The first is observable from
    NAV, so the second is what remains:

        flow = closing AUM - (opening AUM x NAV growth over the month)

    A fund holding 100 crore whose NAV rose 5% should hold 105 crore on
    performance alone. If it holds 110, roughly 5 crore arrived. If it holds
    98, roughly 7 crore left.

    This matters because AUM growth is routinely read as evidence of fund
    quality when much of it is distribution. Separating the two is the point
    of the exercise.

APPROXIMATION, AND WHY
    Money arriving mid-month does not experience the whole month's return,
    so a fund taking heavy inflows during a rising month has its flow
    slightly understated, and the reverse in a falling month. Correcting for
    this needs daily flow data, which is not published. The bias is small
    over a single month and is stated rather than adjusted for.

PRICING DATES ARE DERIVED, NOT ASSUMED
    The stress test disclosures are dated month-end, but month-end is not
    always a day on which every fund published a NAV. 31 March and 30 June
    2024 both fell on a Sunday. Some AMCs published a NAV anyway and others
    did not, and it was not the same set in both months - 23 of 24 published
    on 31 March, but only 3 of 24 on 30 June.

    full_days therefore finds the dates on which all 24 funds published, and
    month_end takes the latest such date on or before each disclosure month.
    Two of the six shift: March prices at the 28th, June at the 28th. Every
    fund is then measured over an identical window.

    Hardcoding the six dates would work for these months and fail silently
    over any other period. It is derived for that reason.

    Note that full_days identifies days on which all 24 funds published, not
    trading days as such. 1 January 2024 was a market holiday and appears in
    the set. It falls in no month-end position here, but the distinction
    matters if this logic is reused.

FEBRUARY HAS NO FLOW
    The lag has nothing to draw on for the first month in the series, so
    February returns NULL. Six months of AUM yield five months of flows.
*/

WITH full_days AS (
    SELECT n.nav_date
    FROM core.nav n
    JOIN core.study_universe u ON n.scheme_code = u.scheme_code
    WHERE n.nav_date >= '2024-01-01'
      AND n.nav_date <= '2024-07-31'
    GROUP BY n.nav_date
    HAVING COUNT(*) = 24
),

month_end AS (
    SELECT DISTINCT ON (s.as_of_date)
        s.as_of_date,
        f.nav_date AS pricing_date
    FROM (SELECT DISTINCT as_of_date FROM core.stress_test) s
    JOIN full_days f ON f.nav_date <= s.as_of_date
    ORDER BY s.as_of_date, f.nav_date DESC
),

priced AS (
    SELECT
        st.amc_code,
        st.as_of_date,
        m.pricing_date,
        st.aum_cr,
        n.nav_value
    FROM core.stress_test st
    JOIN month_end m ON st.as_of_date = m.as_of_date
    JOIN core.study_universe u ON st.amc_code = u.amc
    JOIN core.nav n ON n.scheme_code = u.scheme_code
                   AND n.nav_date = m.pricing_date
),

lagged AS (
    SELECT
        p.amc_code,
        p.as_of_date,
        p.pricing_date,
        p.aum_cr,
        p.nav_value,
        LAG(p.aum_cr)    OVER (PARTITION BY p.amc_code ORDER BY p.as_of_date) AS prev_aum_cr,
        LAG(p.nav_value) OVER (PARTITION BY p.amc_code ORDER BY p.as_of_date) AS prev_nav_value
    FROM priced p
)

SELECT
    l.amc_code,
    f.lumpsum_status,
    l.as_of_date,
    l.prev_aum_cr,
    l.aum_cr,
    ROUND(((l.nav_value / l.prev_nav_value - 1) * 100)::numeric, 2) AS nav_return_pct,
    ROUND((l.aum_cr - l.prev_aum_cr * (l.nav_value / l.prev_nav_value))::numeric, 2) AS flow_cr,
    ROUND((100.0 * (l.aum_cr - l.prev_aum_cr * (l.nav_value / l.prev_nav_value))
           / l.prev_aum_cr)::numeric, 2) AS flow_pct_of_opening
FROM lagged l
JOIN analysis.fund_state_at_event f ON l.amc_code = f.amc
WHERE l.prev_aum_cr IS NOT NULL
ORDER BY l.as_of_date, flow_cr;