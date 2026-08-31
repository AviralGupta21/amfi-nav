/*
001_fund_state_at_event.sql
Each fund's subscription state on 29 February 2024, the last trading day
before the correction. One row per fund house; the grouping every later
comparison filters on.

The event date is hard-coded. It is a fixed historical date, not a parameter,
and a view that silently answered for some other date would be worse than one
that answers only for this one.

DERIVED FROM EVENTS, NOT STORED
    core.amc_restriction holds changes, so the state on a date is the row
    with the greatest effective_date not after it. Axis has five rows and
    only the 2023 one applies here; SBI has two and only the 2021 one does.

FILTERED ON EFFECTIVE DATE, NOT PUBLICATION DATE
    Kotak's addendum was published on 26 February 2024, three days before
    this cutoff, but took effect on 4 March. Keying on publication would
    place it in the restricted group on a date when it was still accepting
    lumpsum investments.

THE JOIN CONDITION SITS IN ON, NOT WHERE
    Fifteen fund houses have no restriction rows at all. A date filter in
    WHERE would discard them and quietly reduce a LEFT JOIN to an inner one,
    returning nine rows that look entirely reasonable.

NULL STATUS IS COALESCED TO open
    A fund house with no applicable row was open, and this is only safe
    because all 24 archives were checked in full. Were any unverified, NULL
    would mean unknown and coalescing it would be inventing data.

    Cap values are deliberately left NULL. A fund with no cap has no cap
    value, and a zero there would corrupt any comparison of severity.

restriction_history
    Three values, because "was this fund restricted" and "has this fund ever
    restricted" are different questions and both matter.

    never_restricted        no restriction row at any date. Fifteen funds.
    previously_restricted   restricted at some point, but open on the event
                            date. DSP, closed from 2017 and reopened in 2020;
                            PGIM, capped and uncapped within a month of launch
                            in 2021. These group with the controls but are
                            controls of a different kind - fund houses that
                            have used the mechanism and chose not to in 2024.
    restricted_at_event     a restriction in force on 29 February 2024.

    Carried as its own column rather than encoded in the status values, since
    a status that means two things cannot be grouped or compared on.

Returns 24 rows: three suspended to lumpsum (SBI, Tata, Nippon), one capped
at a level that binds no retail investor (Axis), twenty open - of which two
had been restricted before and reopened.
*/

CREATE VIEW analysis.fund_state_at_event AS
    SELECT DISTINCT ON (u.amc) 
        u.amc, 
        u.scheme_code, 
        r.effective_date, 
        COALESCE(r.lumpsum_status, 'open') AS lumpsum_status,
        r.lumpsum_cap_value, 
        r.lumpsum_cap_unit, 
        COALESCE(r.sip_status, 'open') AS sip_status,
        r.sip_cap_value, 
        r.sip_cap_unit,
        CASE 
            WHEN r.effective_date IS NULL THEN 'never_restricted'
            WHEN r.lumpsum_status = 'open' THEN 'previously_restricted'
            ELSE 'restricted_at_event' 
        END AS restriction_history
    FROM core.study_universe u 
    LEFT JOIN core.amc_restriction r ON u.amc = r.amc AND r.effective_date <= '2024-02-29' 
    ORDER BY u.amc, r.effective_date DESC;