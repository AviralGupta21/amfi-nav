/*
003_recovery_by_fund.sql
How long each fund took to regain its pre-event high after the 13 March 2024
trough. All 24 recovered; none failed to.

WHY DAYS FROM TROUGH, NOT FROM PEAK
    Every fund bottomed on 13 March 2024 without exception, so a measure
    anchored to the trough starts all 24 from the same day and is directly
    comparable across the universe.

    This is the cleanest comparison the project has. The drawdown columns in
    002 both carry a runway artefact - funds peaked across a three week
    spread, so depth favours late peakers and rate favours early ones, and
    neither is sound across the whole 24. Recovery has no such problem.

FIRST DAY AT OR ABOVE THE OLD HIGH
    DISTINCT ON with an ascending date ordering returns the earliest such
    day. The WHERE clause keeps only post-trough days where NAV had reached
    the pre-event peak; the ordering picks the first of them.

    A fund that never regained its peak would simply be absent. All 24 are
    present, so the recovery was universal - but check the row count if this
    is ever rerun over a different window.

Findings, as of the run on 1 September 2026:

    Twenty funds recovered in 19 to 28 days, most of them 21 to 23, back
    above their February highs by the first week of April.

    Four took 42 to 43 days, returning on 24-25 April: Axis, Baroda BNP
    Paribas, Union and UTI. There is a clean gap between 28 days and 42 -
    nothing falls in between. Three of the four were among the deepest
    fallers; Axis was mid-pack at -8.58%, so depth does not account for the
    group.

    Depth explains part of recovery speed and not most of it. Across all 24
    the correlation between drawdown and days to recover is about -0.45 -
    shallower falls do return sooner - but that leaves roughly four fifths
    of the variation unaccounted for. Among the eight deepest falls, recovery
    ranges from 22 to 43 days.

    Restriction status does not explain recovery either. SBI recovered second
    fastest at 19 days, but it also fell least of all 24, and sits exactly
    where the depth relationship predicts. Nippon is third fastest and
    likewise close to the line. Tata recovered in 22 days after a -10.75%
    fall, well ahead of what its depth predicts - but five unrestricted funds
    did the same, so it is one case among six rather than a pattern.

    Open: what separates the four slow recoverers. Not depth, not
    restriction status, not peak cluster - three peaked early, and so did
    twelve of the fast group. Nothing in the current data accounts for it.
*/

CREATE VIEW analysis.recovery_by_fund AS
    SELECT DISTINCT ON (d.amc)
        d.amc,
        f.scheme_code,
        d.lumpsum_status,
        d.restriction_history,
        d.drawdown_pct,
        d.trough_date,
        d.peak_nav,
        n.nav_date AS recovery_date,
        (n.nav_date::date - d.trough_date::date) AS days_to_recover
    FROM analysis.drawdown_by_fund d
    JOIN analysis.fund_state_at_event f ON d.amc = f.amc
    JOIN core.nav n ON n.scheme_code = f.scheme_code
    WHERE n.nav_date > d.trough_date
      AND n.nav_value >= d.peak_nav
    ORDER BY d.amc, n.nav_date ASC;