# amfi-nav

A PostgreSQL pipeline over Indian mutual fund data, built to study how asset management
companies responded to SEBI's small-cap liquidity intervention of February–March 2024.

> **Status: in progress.** Research and data sourcing complete; ingestion underway.
> Findings below are preliminary and marked as verified or hypothesised.

---

## The question

In late February 2024, AMFI — acting on a communication from SEBI — asked fund houses to
moderate inflows into small and mid-cap funds, and required them to publish fortnightly
liquidity stress tests. Small-cap indices fell roughly 13% over the following month, and the
category recorded its first net outflow in 30 months.

Every fund house faced the same rule on the same date. **They responded differently** — some
suspended lumpsum investments entirely, some capped SIPs, some raised exit loads, some did
nothing, and some later reversed course.

This project asks:

1. Did the funds that restricted inflows behave measurably differently through the correction
   and the recovery?
2. Of the funds that were affected, **why did some hold up better than others?** Does pre-event
   portfolio liquidity, cash position, or investor concentration explain the difference?
3. How much of each fund's AUM movement was performance, and how much was investor flow?

Question 3 matters most. AUM growth is routinely reported as evidence of fund quality when it
is often just distribution. Separating the two is the analytical core of this project.

---

## Data

| Source | What it provides | Coverage |
|---|---|---|
| AMFI daily NAV history | Daily NAV per scheme | 36.7M rows, 38,107 scheme codes, Apr 2006 – present |
| AMC stress test disclosures | Liquidation days, cash %, cap-segment split, investor concentration, beta, PE, turnover — **and monthly scheme-level AUM** | Feb 2024 onward, mid & small cap schemes only |
| AMC addenda | Restriction type, effective date, reversal date | Manually compiled from primary filings |

All sources are public regulatory disclosures. No paid or licensed data is used.

**On data sources and quality:** the historical NAV archive used here is a community mirror of
AMFI's published data, and it has been cleaned on import — every NAV value is numerically typed
and every date is ISO-formatted across all 36.7 million rows. AMFI's own published feed is not
that tidy. The pipeline therefore reads the mirror for historical depth and goes directly to
AMFI's source files for the analysis window, so that ingestion handles real input rather than
pre-sanitised input.

The defects that matter here are not type errors anyway. They are semantic: NAVs unchanged
across consecutive trading days, missing business days, Direct plans priced below their Regular
counterparts when lower expenses make that impossible, scheme codes that discontinue at mergers.
Catching those requires knowing what the numbers mean, which is the point.

---

## Preliminary findings

**✅ Verified — liquidity evaporates exactly when it is needed.**
Nippon India Small Cap Fund's AUM *fell* 1.7% during March 2024, yet the time required to
liquidate half its portfolio *rose* from 27 to 29 days. A smaller portfolio should be easier to
sell; it became harder because the metric depends on market trading volumes as well as fund size,
and volumes contracted during the correction. By June, with AUM 23% higher than February, the
figure had fallen back to 26 days. **The stress test measures market conditions at least as much
as it measures the fund.**

**🔬 Hypothesis — the category-level outflow may mask large dispersion between fund houses.**
The small-cap category recorded a ₹94 crore net outflow in March 2024. Over the same month,
Nippon's two disclosed schemes show AUM changes far smaller than the index decline would imply,
which is only possible if new money was arriving. If individual fund houses took inflows while
the category bled, the headline figure conceals the more interesting story. *Not yet tested —
requires the NAV-based flow decomposition.*

**✅ Verified — a fund's identity is stable in its code and unstable in its name.**
Nippon India's mid-cap fund appears in the regulatory disclosure as "Nippon India Growth Fund",
in the NAV archive as "Nippon India Growth Mid Cap Fund", and in its pre-2019 form as "Reliance
Growth Fund" — with nine distinct codes across the plan and option variants, written in three
different separator conventions and two different casings. Matching these records by name fails
silently; matching by code does not. The reconciliation layer is built on that distinction.

---

## Repository structure

```
sql/schema/     table, index and constraint definitions
sql/load/       staging and bulk-load steps
sql/analysis/   the queries behind the findings above
scripts/        data acquisition and orchestration
notes/          working notes as the analysis develops
NOTES.md        domain concepts, vocabulary and source documentation
DECISIONS.md    every design decision with its reasoning
```

`DECISIONS.md` is the file to read if you want to know *why* the project is built this way.
Scope choices, rejected alternatives, and corrections to earlier assumptions are all recorded
there, including the ones that turned out to be wrong.

---

## Reproducing this

Raw data is not committed — the repository holds the code that builds the database, not the
database itself. Acquisition scripts and load order are in `scripts/` and `sql/load/`.

*Setup instructions to follow once the ingestion layer is complete.*

---

## Notes on scope

The analysis is deliberately bounded by what public data can actually support. Scheme-level AUM
is published quarterly by AMFI, which is too coarse for a month-long event — the stress test
disclosures supply monthly AUM, but only for mid and small cap schemes and only from February 2024.
Where a question cannot be answered within those limits, it is documented as a limitation rather
than estimated around.

The full archive is loaded — all 38,107 scheme codes — but scheme names are parsed into a clean
plan and option hierarchy only for the schemes the analysis touches. The remainder are largely
closed-ended fixed maturity plans that matured years before the event studied here, and building
a universal parser for them would be effort spent on data the questions never reach. This is a
scope decision, not an omission.
