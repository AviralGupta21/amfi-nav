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
| AMFI daily NAV history | Daily NAV per scheme | Full history, all schemes |
| AMC stress test disclosures | Liquidation days, cash %, cap-segment split, investor concentration, beta, PE, turnover — **and monthly scheme-level AUM** | Feb 2024 onward, mid & small cap schemes only |
| AMC addenda | Restriction type, effective date, reversal date | Manually compiled from primary filings |

All sources are public regulatory disclosures. No paid or licensed data is used.

**On data quality:** AMFI's published NAV data contains genuine defects — invalid ISINs
(`NOTAPP`, malformed prefixes, case inconsistencies) and non-numeric NAV values (`#N/A`,
`#DIV/0!`, `B.C.`). These are not synthetic. A reconciliation layer that catches and classifies
them is a deliverable of this project, not a preliminary step.

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
