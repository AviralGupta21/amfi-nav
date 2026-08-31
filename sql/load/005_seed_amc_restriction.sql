/*
005_seed_amc_restriction.sql
The 19 restriction events recorded across the study universe, compiled from
the fund houses' own notice-cum-addenda. Nine of the 24 fund houses have rows here. 
The other fifteen never changed their small cap subscription terms at all.

Only three fund houses imposed a genuinely new restriction in the month
following the 27 February 2024 SEBI communication. Two of the four that
acted in that window were already restricted and merely tightened terms.

WHAT IS AND IS NOT AN EVENT
    Reopenings are events and appear as rows with both statuses open - DSP
    in 2020, PGIM in 2021, Kotak in July 2024, ICICI in January 2026. An
    absent fund house is one that never had an event at all. The two are
    different and should not be conflated when deriving state.

CUMULATIVE CAPS
    Axis and PGIM cap lumpsum and systematic plans against a single shared
    limit rather than separately, so the same figure appears in both cap
    columns. Every other fund house caps them independently, and Tata
    suspended lumpsum while leaving systematic registrations entirely
    uncapped.

CAP UNITS DIFFER BETWEEN FUND HOUSES
    Some limits are per day, some per month. The nominal figures are not
    comparable without the unit - twenty five thousand a month and fifty
    thousand a day differ by roughly sixty times over a year.

Rows carrying a known weakness, flagged in note:

axis, effective 2021-10-01
    Publication date not recovered; set equal to the effective date.

axis, effective 2023-05-15
    The addendum itself was not located on the fund house's archive. Terms
    are taken from a scheme presentation that restates them. Publication
    date set equal to the effective date.

Source documents are not linked. Each row is identified by fund house, date
and addendum reference where the filing carries one; two of these archives
have been relocated already and stored links would not survive.
*/

INSERT INTO core.amc_restriction VALUES
('sbi','2020-09-04','2020-09-08','suspended',NULL,NULL,'capped',5000,'per_month_per_pan',NULL,NULL,NULL),
('sbi','2021-02-03','2021-02-04','suspended',NULL,NULL,'capped',25000,'per_month_per_pan',NULL,NULL,NULL),
('axis','2020-01-27','2020-01-31','capped',20000000,'per_day_per_pan','capped',20000000,'per_day_per_pan',NULL,'54/2019-20','Cap is cumulative across lumpsum and systematic plans'),
('axis','2020-03-05','2020-03-11','capped',500000,'per_day_per_pan','capped',500000,'per_day_per_pan',NULL,'59/2019-20','Cumulative cap'),
('axis','2020-03-30','2020-04-01','capped',10000000,'per_day_per_pan','capped',10000000,'per_day_per_pan',NULL,'66/2019-20','Cumulative cap'),
('axis','2021-10-01','2021-10-01','capped',500000,'per_day_per_pan','capped',500000,'per_day_per_pan',NULL,'40/2021-22','Publication date not recovered; set equal to effective date'),
('axis','2023-05-15','2023-05-15','capped',10000000,'per_day_per_pan','capped',10000000,'per_day_per_pan',NULL,NULL,'Addendum not located; terms from fund PPT. Publication date set equal to effective date'),
('tata','2023-06-26','2023-07-01','suspended',NULL,NULL,'open',NULL,NULL,NULL,NULL,'New SIP/STP registrations explicitly unaffected'),
('nippon','2023-07-06','2023-07-07','suspended',NULL,NULL,'capped',500000,'per_day_per_pan',NULL,'No. 20 of 2023-24','Corrigendum same date removed the phrase SIP without initial investment'),
('nippon','2024-03-19','2024-03-22','suspended',NULL,NULL,'capped',50000,'per_day_per_pan','1% within 1 month changed to 1% within 1 year','No. 94','Tightening of the July 2023 restriction'),
('pgim','2021-07-29','2021-08-02','capped',1000000,'per_day_per_pan','capped',1000000,'per_day_per_pan',NULL,'No. 15 of 2021-22','Cumulative cap per application/instalment, shortly after launch'),
('pgim','2021-08-30','2021-09-01','open',NULL,NULL,'open',NULL,NULL,NULL,'No. 18 of 2021-22','Limit withdrawn'),
('kotak','2024-02-26','2024-03-04','capped',200000,'per_month_per_pan','capped',25000,'per_month_per_pan',NULL,NULL,'Addendum dated one day before the 27 Feb 2024 SEBI communication'),
('kotak','2024-07-01','2024-07-02','open',NULL,NULL,'open',NULL,NULL,NULL,NULL,'All limits removed'),
('icici','2024-03-12','2024-03-14','suspended',NULL,NULL,'capped',200000,'per_month_per_pan',NULL,'No. 007/03/2024','Cut-off 3pm 13 Mar 2024. Also covered ICICI Prudential Midcap Fund'),
('icici','2024-07-02','2024-07-05','suspended',NULL,NULL,'capped',200000,'per_month_per_pan',NULL,'No. 003/07/2024','Partial modification: Freedom SIP registrations restored, monthly frequency only'),
('icici','2026-01-21','2026-01-23','open',NULL,NULL,'open',NULL,NULL,NULL,'No. 009/01/2026','All PAN-level restrictions withdrawn. Names Smallcap Fund only; Midcap status unverified'),
('franklin','2024-03-17','2024-03-18','capped',200000,'per_month_per_pan','capped',50000,'per_month_per_pan',NULL,NULL,'Franklin India Smaller Companies Fund'),
('dsp','2020-03-25','2020-04-01','open',NULL,NULL,'open',NULL,NULL,NULL,NULL,'Reopening. Closed to fresh inflows Feb 2017, SIP-only from Sep 2018. Two addenda filed same day (SID and KIM)');