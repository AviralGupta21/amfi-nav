/*
002_drawdown_by_fund.sql
Peak-to-trough fall for each of the 24 funds through the February-March 2024
small cap correction, joined to each fund's subscription state on the eve of
the event.

PER-FUND PEAKS, NOT FIXED DATES
    Each fund's own high and its own subsequent low, rather than the change
    between two dates common to all. A fixed-date comparison would blend the
    depth of a fall with its timing; this measures the damage each fund
    actually took.

    The cost is that the windows differ in length - funds peaked across a
    three week spread while all of them bottomed on the same day - so
    peak_date is returned alongside the percentage rather than hidden.

WHY THE PEAK WINDOW ENDS 29 FEBRUARY
    Searched over January and February only. Every fund had recovered past
    its pre-event high by 30 April, so a window running to the end of the
    period returns the recovery as the peak and produces no drawdown at all.
    An earlier draft of this query did exactly that: 23 of 24 funds reported
    a peak dated 30 April.

    The bound is a judgement. A fund peaking in early March would have its
    peak clipped at the boundary; none did - the latest is 27 February.

THE TROUGH MUST FOLLOW THAT FUND'S OWN PEAK
    Hence two CTEs rather than a MIN and a MAX. The trough search starts at
    each fund's peak date and runs to 30 April, and the strict inequality
    matters: a fund whose lowest NAV preceded its high would otherwise
    report a fall it never took.

ROUND REQUIRES A NUMERIC CAST
    nav is double precision, and Postgres has no two-argument round() for
    floating point. The cast wraps the whole expression, not the literal.

Findings, as of the run on 1 September 2026:

    All 24 funds troughed on 13 March 2024. Not one exception. The bottom
    was a single market-wide event; portfolio differences did not shift its
    timing by even a day.

    Peaks were not synchronised. Fifteen funds turned on 6-7 February,
    three weeks before the regulatory communication of 27 February; the
    other nine were still making highs as late as the 27th itself.

    Drawdowns span -6.17% to -11.30%. The three funds closed to lumpsum on
    the event date sit at rank 1, 20 and 5 of 24 - the shallowest fall in
    the universe, and one of the deepest. Restriction status does not sort
    the drawdowns, and with three treated funds it could not establish that
    it did.

    Peak date looks more informative than restriction status: the shallowest
    falls cluster among funds that peaked latest. Untested.
*/

CREATE VIEW analysis.drawdown_by_fund AS
    WITH peak AS 
    (
        SELECT DISTINCT ON (f.amc)
            f.amc,
            f.scheme_code,
            n.nav_value AS peak_nav,
            n.nav_date AS peak_date
        FROM core.nav n
        JOIN analysis.fund_state_at_event f ON n.scheme_code = f.scheme_code
        WHERE n.nav_date BETWEEN '2024-01-01' AND '2024-02-29'
        ORDER BY f.amc, n.nav_value DESC       
    ),
    trough AS
    (
        SELECT DISTINCT ON (p.amc)
            p.amc, 
            p.scheme_code,
            n.nav_value AS trough_nav,
            n.nav_date AS trough_date
        FROM core.nav n
        JOIN peak p ON n.scheme_code = p.scheme_code
        WHERE n.nav_date > p.peak_date AND n.nav_date <= '2024-04-30'
        ORDER BY p.amc, n.nav_value ASC
    ) 
    SELECT 
        f.amc,
        f.lumpsum_status,
        f.restriction_history,
        p.peak_date,
        p.peak_nav,
        t.trough_date,
        t.trough_nav,
        ROUND(((t.trough_nav - p.peak_nav)/p.peak_nav * 100)::NUMERIC, 2) AS drawdown_pct
    FROM peak p
    JOIN trough t ON p.amc = t.amc
    JOIN analysis.fund_state_at_event f ON p.amc = f.amc
    ORDER BY drawdown_pct ASC;

