/*
006_scheme_lineage.sql
Records schemes whose history continues under a different scheme code.

When a fund house is acquired, the surviving AMC sometimes issues new
scheme codes for the same underlying fund. The NAV series then splits
across two codes with nothing in the data linking them, and querying
either one returns a truncated history.

Only cases where the CODE CHANGED are recorded here. Bandhan's rebrand
from IDFC kept the original codes and so does not appear, despite being a
corporate event. A rebrand usually renames in place; an acquisition may or
may not reissue codes. Nothing in the data distinguishes them, so each case
is established from corporate history and confirmed against the NAV dates.

Both boundary dates are stored rather than a single transition date. The
adjacency between them is the evidence that the two codes are one fund, and
storing both keeps that claim auditable.

NAV levels are not continuous across a transition. Analysis crossing a
lineage boundary must use returns, not levels.

Seeded after core.schemes is loaded, since both columns reference it.
*/

CREATE TABLE core.scheme_lineage
(
    predecessor_scheme_code INTEGER NOT NULL REFERENCES core.schemes(scheme_code),
    successor_scheme_code INTEGER NOT NULL REFERENCES core.schemes(scheme_code),
    predecessor_last_nav DATE NOT NULL,
    successor_first_nav DATE NOT NULL,
    reason TEXT NOT NULL,
    note TEXT NOT NULL,
    CONSTRAINT pk_scheme_lineage PRIMARY KEY (predecessor_scheme_code, successor_scheme_code),
    CONSTRAINT ck_lineage_order CHECK (successor_first_nav > predecessor_last_nav),
    CONSTRAINT ck_lineage_reason CHECK (reason IN ('acquisition', 'merger', 'rebrand', 'recategorisation'))
);