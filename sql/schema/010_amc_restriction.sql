/*
010_amc_restriction.sql
Subscription restrictions on the small cap schemes in core.study_universe,
compiled from the fund houses' own notice-cum-addenda. No consolidated record
of these exists publicly; each was read from the issuing AMC's filing and
cross-checked against scheme documents and contemporaneous reporting.

ONE ROW PER RESTRICTION EVENT
    A change with an effective date, not one row per document. The two
    differ. DSP filed separate SID and KIM amendments on the same day for a
    single reopening, which is one event. ICICI Prudential issued three
    notices over 22 months - a suspension, a partial relaxation restoring
    one systematic product, and a full withdrawal - which is three.

FUND HOUSES THAT NEVER RESTRICTED HAVE NO ROWS
    Absence here means no event. Membership of the study universe is what
    records that a fund was examined. All 24 archives were walked in full,
    so absence is a verified negative rather than an unchecked one.

STATUS ON A GIVEN DATE IS DERIVED, NOT STORED
    A row describes a change, so the state in force on date X is the row
    with the greatest effective_date not after X. Several fund houses have
    rows predating the analysis window - one revised its cap five times from
    2020, another twice - and only the most recent of those describes the
    state during the event studied.

SEVERITY IS A STATE, NOT A LABEL
    A binary treated/control flag is derived at query time against a stated
    threshold; it is never assigned by hand. The restrictions span two
    orders of magnitude and no single label survives them: one fund house
    suspended lumpsum outright while leaving systematic plans entirely
    uncapped, another capped lumpsum at a level no retail investor would
    reach. Calling both "restricted" produces an incoherent treated group.

CAP UNITS ARE MANDATORY WHEREVER A CAP EXISTS
    Some fund houses set limits per day, others per month, and the same
    nominal figure differs by roughly 60x annually between the two. A bare
    number is unusable and ck_lp_cap_complete and ck_sp_cap_complete
    reject one.

Free text by design:

exit_load_note
    Exit load terms are expressed too variously across filings to structure
    without losing meaning, and no analysis here depends on parsing them.
*/

CREATE TABLE core.amc_restriction ( 
amc TEXT NOT NULL REFERENCES core.study_universe(amc), 
publication_date DATE NOT NULL, 
effective_date DATE NOT NULL, 
lumpsum_status TEXT NOT NULL, 
lumpsum_cap_value NUMERIC, 
lumpsum_cap_unit TEXT, 
sip_status TEXT NOT NULL, 
sip_cap_value NUMERIC, 
sip_cap_unit TEXT, 
exit_load_note TEXT, 
addendum_ref TEXT,  
note TEXT, 
CONSTRAINT pk_amc_restriction PRIMARY KEY (amc, effective_date), 
CONSTRAINT ck_lp_status CHECK (lumpsum_status IN ('open', 'capped', 'suspended')), 
CONSTRAINT ck_lp_cap_unit CHECK (lumpsum_cap_unit IN ('per_day_per_pan', 'per_month_per_pan')), 
CONSTRAINT ck_sp_status CHECK (sip_status IN ('open', 'capped', 'suspended')), 
CONSTRAINT ck_sp_cap_unit CHECK (sip_cap_unit IN ('per_day_per_pan', 'per_month_per_pan')), 
CONSTRAINT ck_effective_after_publication CHECK (effective_date >= publication_date),
CONSTRAINT ck_lp_cap_complete CHECK (
  (lumpsum_status <> 'capped') OR
  (lumpsum_cap_value IS NOT NULL AND lumpsum_cap_unit IS NOT NULL)
),
CONSTRAINT ck_sp_cap_complete CHECK (
  (sip_status <> 'capped') OR
  (sip_cap_value IS NOT NULL AND sip_cap_unit IS NOT NULL)
)
);