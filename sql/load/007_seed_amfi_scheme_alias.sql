/*
007_seed_amfi_scheme_alias.sql
The 24 mappings from AMFI's stress test scheme names to fund house slugs.

NAMES MUST MATCH BYTE FOR BYTE
    These are AMFI's strings exactly as they appear in the disclosure files,
    casing included. SBI SMALL CAP FUND and BANK OF INDIA SMALL CAP FUND are
    fully capitalised in the source; BANDHAN Small Cap Fund is capitalised
    only in part. A single character out of place drops that fund silently
    from every join - no error, just twenty-three funds where there should
    be twenty-four.

FOUR SCHEMES ARE DELIBERATELY ABSENT
    LIC MF Small Cap Fund, Motilal Oswal Small Cap Fund, QUANTUM SMALL CAP
    FUND and JM Small Cap Fund appear in AMFI's files but run no fund in the
    study universe. Their absence here is what filters them out of
    core.stress_test; there is no exclusion list to maintain.

    JM appears only from June 2024 - the fund launched mid-year - which is
    why the source files carry 27 schemes through May and 28 thereafter.

Verification after loading:

    SELECT COUNT(DISTINCT s.raw_scheme_name)
    FROM staging.stress_test_raw s
    JOIN core.amfi_scheme_alias a USING (raw_scheme_name);

    Expect 24. Anything less means a name does not match.

    SELECT DISTINCT raw_scheme_name FROM staging.stress_test_raw
    EXCEPT SELECT raw_scheme_name FROM core.amfi_scheme_alias;

    Expect exactly the four schemes named above. A fifth is a typo.
*/

INSERT INTO core.amfi_scheme_alias (raw_scheme_name, amc) VALUES
('Aditya Birla Sun Life Small Cap Fund',    'absl'),
('Axis Small Cap Fund',                     'axis'),
('BANDHAN Small Cap Fund',                  'bandhan'),
('BANK OF INDIA SMALL CAP FUND',            'boi'),
('Baroda BNP Paribas Small Cap Fund',       'barodabnp'),
('Canara Robeco Small Cap Fund',            'canara'),
('DSP Small Cap Fund',                      'dsp'),
('Edelweiss Small Cap Fund',                'edelweiss'),
('Franklin India Smaller Companies Fund',   'franklin'),
('HDFC Small Cap Fund',                     'hdfc'),
('HSBC Small Cap Fund',                     'hsbc'),
('ICICI Prudential Smallcap Fund',          'icici'),
('Invesco India Smallcap Fund',             'invesco'),
('ITI Small Cap Fund',                      'iti'),
('Kotak Small Cap Fund',                    'kotak'),
('Mahindra Manulife Small Cap Fund',        'mahindra'),
('Nippon India Small Cap Fund',             'nippon'),
('PGIM India Small Cap Fund',               'pgim'),
('Quant Small Cap Fund',                    'quant'),
('SBI SMALL CAP FUND',                      'sbi'),
('Sundaram Small Cap Fund',                 'sundaram'),
('Tata Small Cap Fund',                     'tata'),
('Union Small Cap Fund',                    'union'),
('UTI Small Cap Fund',                      'uti');