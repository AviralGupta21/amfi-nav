/*
004_seed_study_universe.sql
The 24 scheme codes making up the study universe, one per fund house.

Selected by hand from 210 candidate rows returned by name matching, not by
filter. The reasoning and the specific cases where a plausible filter picks
the wrong row are in 009_study_universe.sql.

Every code is the DIRECT plan, GROWTH option of that fund house's actively
managed open-ended small cap scheme.

scheme_name is stored as it appeared in the NAV archive on the verification
date, not as the fund house currently markets it. At least one scheme has
been renamed since the filings examined in this project, and the archive
shows the current name against the original code.

Must run before 005_seed_amc_restriction.sql, which references amc here.
*/

INSERT INTO core.study_universe (amc, scheme_code, scheme_name, note) VALUES 
('absl', 119556, 'Aditya Birla Sun Life Small Cap Fund - Growth - Direct Plan', NULL),
('axis', 125354, 'Axis Small Cap Fund - Direct Plan - Growth', NULL),
('bandhan', 147946, 'BANDHAN SMALL CAP FUND - DIRECT PLAN GROWTH', NULL),
('boi', 145678, 'BANK OF INDIA Small Cap Fund Direct Plan Growth', NULL),
('barodabnp', 152128, 'Baroda BNP Paribas Small Cap Fund - Direct Plan - Growth option', NULL),
('canara', 146130, 'CANARA ROBECO SMALL CAP FUND - DIRECT PLAN - GROWTH OPTION', NULL),
('dsp', 119212, 'DSP Small Cap Fund - Direct Plan - Growth', NULL),
('edelweiss', 146196, 'Edelweiss Small Cap Fund - Direct Plan - Growth', NULL),
('franklin', 118525, 'Franklin India Small Cap Fund - Direct - Growth', NULL),
('hdfc', 130503, 'HDFC Small Cap Fund - Growth Option - Direct Plan', NULL),
('hsbc', 151130, 'HSBC Small Cap Fund - Direct Growth', NULL),
('icici', 120591, 'ICICI Prudential Smallcap Fund - Direct Plan - Growth', NULL),
('invesco', 145137, 'Invesco India Smallcap Fund - Direct Plan - Growth', NULL),
('iti', 147919, 'ITI Small Cap Fund - Direct Plan - Growth Option', NULL),
('kotak', 120164, 'Kotak-Small Cap Fund - Growth - Direct', NULL),
('mahindra', 150915, 'Mahindra Manulife Small Cap Fund - Direct Plan - Growth', NULL),
('nippon', 118778, 'Nippon India Small Cap Fund - Direct Plan Growth Plan - Growth Option', NULL),
('pgim', 149019, 'PGIM India Small Cap Fund - Direct Plan- Growth Option', NULL),
('sbi', 125497, 'SBI Small Cap Fund - Direct Plan - Growth', NULL),
('sundaram', 119589, 'Sundaram Small Cap Fund Direct Plan - Growth', NULL),
('tata', 145206, 'Tata Small Cap Fund-Direct Plan-Growth', NULL),
('uti', 148618, 'UTI Small Cap Fund - Direct Plan - Growth Option', NULL),
('union', 129649, 'Union Small Cap Fund - Direct Plan - Growth Option', NULL),
('quant', 120828, 'quant Small Cap Fund - Growth Option - Direct Plan', NULL);