/*
001_seed_amc.sql
Seeds core.amc with the 24 fund houses in the study universe.

The universe was derived from the NAV archive rather than from a published
list: scheme names filtered for small-cap markers, excluding index funds,
ETFs, fund-of-funds, closed-ended series and hybrids, then restricted to
schemes with NAV coverage spanning the event window and at least twelve
months of history before it.

This is reference data, so it lives in version control as INSERT statements
rather than as a CSV in data/. A CSV would be gitignored and the lookup
could not be reproduced from a clone.

disclosures_url is deliberately left null. The URLs are collected while
harvesting the stress test files, so a null here means not yet visited
rather than not available.

Idempotent: ON CONFLICT DO NOTHING, so re-running changes nothing.
Adding a fund house to the study means adding a row here.
*/

INSERT INTO core.amc (amc_code, amc_name)
VALUES
    ('absl', 'Aditya Birla Sun Life Mutual Fund'),
    ('axis', 'Axis Mutual Fund'),
    ('bandhan', 'Bandhan Mutual Fund'),
    ('boi', 'Bank of India Mutual Fund'),
    ('barodabnp', 'Baroda BNP Paribas Mutual Fund'),
    ('canara', 'Canara Robeco Mutual Fund'),
    ('dsp', 'DSP Mutual Fund'),
    ('edelweiss', 'Edelweiss Mutual Fund'),
    ('franklin', 'Franklin Templeton Mutual Fund'),
    ('hdfc', 'HDFC Mutual Fund'),
    ('hsbc', 'HSBC Mutual Fund'),
    ('icici', 'ICICI Prudential Mutual Fund'),
    ('iti', 'ITI Mutual Fund'),
    ('invesco', 'Invesco Mutual Fund'),
    ('kotak', 'Kotak Mahindra Mutual Fund'),
    ('mahindra', 'Mahindra Manulife Mutual Fund'),
    ('nippon', 'Nippon India Mutual Fund'),
    ('pgim', 'PGIM India Mutual Fund'),
    ('sbi', 'SBI Mutual Fund'),
    ('sundaram', 'Sundaram Mutual Fund'),
    ('tata', 'Tata Mutual Fund'),
    ('uti', 'UTI Mutual Fund'),
    ('union', 'Union Mutual Fund'),
    ('quant', 'quant Mutual Fund')
ON CONFLICT (amc_code) DO NOTHING;