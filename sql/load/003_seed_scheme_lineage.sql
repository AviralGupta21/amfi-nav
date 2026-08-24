/*
003_seed_scheme_lineage.sql
Seeds core.scheme_lineage.

One row. L&T Emerging Businesses Fund continues as HSBC Small Cap Fund
following the 2022 acquisition, under different scheme codes.

This was the only code-changing corporate event found among the 24 fund
houses in the study universe. Bandhan's rebrand from IDFC kept its
original codes and so is not recorded here.

Only the Direct Growth plan-option pair is seeded. Other plan-option
pairs exist and can be added if the analysis needs them.

Idempotent: ON CONFLICT DO NOTHING on the composite key.

Depends on core.schemes being loaded.
*/

INSERT INTO core.scheme_lineage (predecessor_scheme_code, successor_scheme_code, predecessor_last_nav, successor_first_nav, reason, note)
VALUES 
    (129220, 151130, '2022-11-25', '2022-11-28', 'acquisition', 'HSBC acquired L&T Mutual Fund in 2022. L&T Emerging Businesses Fund became HSBC Small Cap Fund under new scheme codes. Link established from date adjacency: 129220 ends 2022-11-25, 151130 begins 2022-11-28, three days and one weekend apart with no overlap. Both codes are the Direct Growth plan-option. The fund has four plan-option codes on each side; only this pair is recorded, since the analysis uses Direct Growth. Add the remaining pairs if other plans are needed.')
ON CONFLICT (predecessor_scheme_code, successor_scheme_code) DO NOTHING;