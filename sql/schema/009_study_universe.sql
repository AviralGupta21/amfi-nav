/*
009_study_universe.sql
The 24 fund houses in scope: those running an actively managed open-ended
small cap scheme. One row per fund house, naming the single AMFI scheme code
whose NAV series represents that fund in this analysis.

DIRECT PLAN, GROWTH OPTION
    Direct carries no distribution commission, so returns are not dragged by
    a fee that varies between fund houses. Growth pays no income
    distribution, so every NAV move is a market move - an IDCW option's NAV
    falls on each payout, which a drawdown calculation cannot distinguish
    from a loss.

SELECTED BY HAND, NOT BY PATTERN MATCH
    Matching scheme names for "small cap" returns 210 rows over the study
    window: index funds and ETFs tracking small cap benchmarks, fund houses
    outside the study universe, closed-ended series, a hybrid equity and
    debt scheme, and multiple plan and option variants of each fund. Across
    the 24 funds the archive uses ten different conventions for what is the
    same thing - "Direct Plan - Growth", "Growth - Direct", "DIRECT PLAN
    GROWTH", "Growth Option - Direct Plan", among others - so no filter
    separates them reliably. A filter that looks correct returns 24 rows
    whether or not they are the right 24, and nothing errors when they are
    not.

Cases where a plausible filter picks the wrong row:

Nippon India Small Cap Fund
    A Bonus option (118777) sits beside the Growth option (118778); both
    names contain "Direct Plan Growth Plan".

quant vs QUANTUM
    Different fund houses. Only quant is in scope.

Franklin
    The Direct plan is 118525. Code 103360 carries a similar name but is the
    Regular plan.

Bank of India
    Also runs a Mid & Small Cap Equity & Debt Fund, a hybrid scheme outside
    the universe.

Sundaram
    The open-ended fund shares its name stem with the closed-ended Emerging
    Small Cap and Select Small Cap series.

Column notes:

scheme_name
    The fund's name in the NAV archive as verified on the date in
    verified_on. Deliberately NOT a foreign key: names change while codes do
    not. Franklin India Smaller Companies Fund was renamed after the March
    2024 filings examined here, and the archive now shows the current name
    against the original code. The stored copy preserves what was actually
    checked.

amc
    Primary key. The universe is defined as one fund per fund house.

scheme_code
    UNIQUE, so no code can be claimed by two fund houses.

Held separately:

Restriction status
    A fund belongs to this universe whether or not it was ever restricted.
    Separating the two keeps membership and treatment independent.
*/

CREATE TABLE core.study_universe 
(
amc TEXT,
scheme_code INTEGER NOT NULL REFERENCES core.schemes(scheme_code),
scheme_name TEXT NOT NULL,
note TEXT,
verified_on DATE NOT NULL DEFAULT CURRENT_DATE,
CONSTRAINT pk_study_universe PRIMARY KEY (amc),
CONSTRAINT uq_study_universe UNIQUE(scheme_code)
);