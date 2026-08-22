/*
002_schemes.sql
The scheme dimension: one row per AMFI scheme code.

Source: historical NAV archive (SQLite), schemes table.
38,107 rows spanning April 2006 to present.

scheme_name is stored exactly as published. It is not normalised and not
parsed here. Naming was never standardised across fund houses, so the same
fund appears under different names, separators and casings depending on
vintage. Any parsed hierarchy belongs in a derived table so this one stays
faithful to the source and can be re-derived from.

Most codes are discontinued closed-ended schemes rather than live funds.

Referenced by nav and securities, so this file runs before both.
*/

CREATE TABLE core.schemes
(
    scheme_code INTEGER,
    scheme_name TEXT NOT NULL,
    CONSTRAINT pk_schemes PRIMARY KEY (scheme_code)
);