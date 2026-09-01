# amfi-nav

A PostgreSQL pipeline over Indian mutual fund data, built to study how asset management
companies responded to SEBI's small-cap liquidity intervention of February–March 2024.

> **Status: analysis in progress.** The regulatory dataset is complete and primary-sourced
> across all 24 fund houses in scope. The drawdown and recovery analyses are complete; flow
> decomposition is underway. Findings below are marked verified or hypothesised.

---

## The question

On 27 February 2024, SEBI directed AMFI to require every fund house to frame a policy protecting
investors in small and mid-cap schemes, and to publish regular liquidity stress tests. Small-cap
indices fell roughly 13% over the following month, and the category recorded its first net
outflow in 30 months.

The mandate was procedural — *have a policy* — not an instruction to restrict. Every fund house
faced it on the same day, and each was free to respond as it chose. That makes the episode a
natural experiment in how fund managers actually behave when a regulator signals concern.

This project asks:

1. **How did fund houses actually respond?** Who restricted inflows, when, how severely, and for
   how long?
2. **Does the timing support a causal story** about the correction, or not?
3. **How much of each fund's AUM movement was performance, and how much was investor flow?**

Question 3 matters most analytically. AUM growth is routinely reported as evidence of fund
quality when it is often just distribution. Separating the two requires daily NAV data and is
the core of the pipeline.

---

## What this repository contains that you cannot easily get elsewhere

The central asset here is a **complete, primary-sourced record of small-cap subscription
restrictions across all 24 Indian fund houses running an actively managed small-cap scheme.**

No such consolidated record is published. Each fund house files restrictions as
"notice-cum-addendum" PDFs on its own website, under a different menu path, with a different
numbering convention and no predictable filenames. Press coverage is partial and, in several
cases, factually wrong about dates and amounts.

Every row below was read from the fund house's own addendum and cross-checked. **You do not need
to visit any AMC website to use this repository.**

---

## The regulatory dataset

### Restriction status across the study universe

| Fund house | Small-cap state entering Feb 2024 | Acted in the Feb–Mar 2024 window |
|---|---|---|
| SBI | Lumpsum closed since 08 Sep 2020 | — |
| Tata | Lumpsum closed since 01 Jul 2023 | — |
| Nippon India | Lumpsum closed since 07 Jul 2023 | **Yes** — tightened, eff. 22 Mar 2024 |
| Kotak Mahindra | Open | **Yes** — eff. 04 Mar 2024 |
| ICICI Prudential | Open | **Yes** — eff. 14 Mar 2024 |
| Franklin Templeton | Open | **Yes** — eff. 18 Mar 2024 |
| Axis | Nominal ₹1 crore/day cap since May 2023 | — |
| Aditya Birla Sun Life | Open | — |
| Bandhan | Open | — |
| Bank of India | Open | — |
| Baroda BNP Paribas | Open | — |
| Canara Robeco | Open | — |
| DSP | Open (was closed 2017–2020) | — |
| Edelweiss | Open | — |
| HDFC | Open | — |
| HSBC | Open | — |
| Invesco | Open | — |
| ITI | Open | — |
| Mahindra Manulife | Open | — |
| PGIM India | Open (briefly capped Aug 2021) | — |
| Sundaram | Open | — |
| UTI | Open | — |
| Union | Open | — |
| quant | Open | — |

**Three fund houses were already closed to lumpsum before the mandate. Four acted within the
window. Seventeen did nothing.**

### Restriction severity, for those that restricted

Restrictions are not binary. Lumpsum status and systematic-plan caps move independently, and
severity spans two orders of magnitude.

| Fund house | Lumpsum | Fresh SIP/STP cap |
|---|---|---|
| Tata | Suspended | Uncapped |
| SBI | Suspended | ₹25,000 / month / PAN |
| Nippon India | Suspended | ₹50,000 / **day** / PAN (from 22 Mar 2024; previously ₹5 lakh/day) |
| ICICI Prudential | Suspended | ₹2,00,000 / month / PAN |
| Kotak Mahindra | ₹2,00,000 / month / PAN | ₹25,000 / month / PAN |
| Franklin Templeton | ₹2,00,000 / month / PAN | ₹50,000 / month / PAN |
| Axis | ₹1 crore / **day** / PAN | Included in the same cumulative cap |

Note the units: some caps are monthly, some daily. SBI's ₹25,000/month and Nippon's
₹50,000/day differ by roughly 60× in annual terms. The schema stores value and unit separately
for this reason, and any binary treated/control flag is derived from a stated severity
threshold rather than assigned by hand.

### Reversals

Two fund houses reopened, giving complete open → closed → open cycles:

| Fund house | Closed | Reopened | Duration |
|---|---|---|---|
| Kotak Mahindra | 04 Mar 2024 | 02 Jul 2024 | 4 months |
| ICICI Prudential | 14 Mar 2024 | 23 Jan 2026 | 22 months |

ICICI additionally restored one systematic product (Freedom SIP) on 05 Jul 2024 while keeping
lumpsum suspended, and was the only fund house to state a reopening condition in the original
notice: lumpsum would resume when, in its assessment, valuations became attractive.

---

## Findings

**✅ Verified — the intervention produced almost no new restrictions.**
Of 24 fund houses, four changed their small-cap subscription terms in the month following the
SEBI communication. Two of those four were already restricted and merely tightened. **Three
genuinely new restrictions resulted: Kotak, ICICI Prudential and Franklin Templeton.**

**✅ Verified — the timing does not support a causal story about the correction.**
Kotak's notice is dated 26 February 2024, *one day before* the SEBI communication — its board
had already decided. The other three took effect on or after the 13 March market trough: ICICI
Prudential on 14 March, Franklin on 18 March, Nippon on 22 March. **No restriction imposed in
this window can have caused or moderated a drawdown that had already ended.**

**✅ Verified — the fund houses that did close moved long before the regulator.**
SBI closed to lumpsum in September 2020, Tata and Nippon in July 2023 — seven months to three
and a half years ahead of the mandate. All cited the small-cap rally and difficulty deploying
new capital, not any regulatory instruction.

**✅ Verified — fund size does not explain who restricted.**
The obvious hypothesis is that the largest funds hit capacity limits first. It does not hold.
HDFC (among the two largest small-cap schemes in India) and quant (the fastest-growing, from
roughly ₹2,000 crore to ₹17,000 crore across 2023) both stayed fully open, while ICICI
Prudential suspended lumpsum on a smaller fund. Tested and rejected.

**✅ Verified — restrictions are a valuation tool, not a crash-protection tool.**
Fund houses consistently loosen during corrections and tighten during rallies — the opposite of
what "restricting inflows protects investors in a fall" would predict. SBI removed its
systematic-plan restrictions in May 2020 mid-COVID and reimposed them that September as markets
recovered. DSP, closed since 2017, fully reopened on 1 April 2020. Axis cut its cap 40× in March
2020 and restored it three weeks later.

**✅ Verified — liquidity evaporates exactly when it is needed.**
Nippon India Small Cap Fund's AUM *fell* 1.7% during March 2024, yet the time required to
liquidate half its portfolio *rose* from 27 to 29 days. A smaller portfolio should be easier to
sell; it became harder because the metric depends on market trading volumes as well as fund
size, and volumes contracted during the correction. By June, with AUM 23% higher than February,
the figure had fallen back to 26 days. **The stress test measures market conditions at least as
much as it measures the fund.**

**✅ Verified — every fund bottomed on the same day, and restriction status did not change how
far it fell.**
All 24 funds reached their lowest NAV on 13 March 2024 — no exceptions, despite different
portfolios, concentrations and cash positions. Peak-to-trough falls span just 5.1 percentage
points, from −6.17% to −11.30%. The three funds closed to lumpsum entering the event rank 1st,
5th and 20th of 24 by depth: SBI, the most heavily restricted fund in the universe, fell least;
Tata, also closed, was 5th deepest. **Restriction status does not sort the drawdowns**, which is
what the timing already implied — three of the four restrictions imposed in the window took
effect on or after the market had bottomed.

**✅ Verified — the correction was fully retraced, and recovery split the universe in two.**
All 24 funds regained their pre-event high. Twenty did so in 19 to 28 days, most within three
weeks of the trough. **Four took 42 to 43 days — Axis, Baroda BNP Paribas, Union and UTI — with
no fund falling anywhere between 28 and 42.** The gap is clean, and nothing in the regulatory or
price data explains it: not how far they fell, not restriction status, not when they peaked, not
fund age.

**✅ Verified — recovery speed is not explained by restriction status either.**
SBI recovered second fastest of 24, at 19 days. But it also fell least, and sits exactly where
the relationship between depth and recovery predicts — there is no residual for restriction to
account for. Depth itself explains only about a fifth of the variation in recovery speed
(r = −0.45), so most of what separates a three-week recovery from a six-week one lies outside
both the price data and the regulatory record.

**✅ Verified — a fund's identity is stable in its code and unstable in its name.**
Nippon India's mid-cap fund appears in the regulatory disclosure as "Nippon India Growth Fund",
in the NAV archive as "Nippon India Growth Mid Cap Fund", and in its pre-2019 form as "Reliance
Growth Fund" — with nine distinct codes across plan and option variants, in three separator
conventions and two casings. Six fund houses in the study universe renamed or merged during the
study period. Matching by name fails silently; matching by code does not.

**🔬 Hypothesis — when a fund peaked may matter more than whether it was restricted.**
Peaks were not synchronised: fifteen funds topped out on 6–7 February 2024, three weeks before
the regulatory communication, while nine were still making highs as late as 27 February — the
day of the communication itself. The shallowest falls cluster among the late peakers. This
points at portfolio composition rather than subscription policy. *Not yet tested.*

**🔬 Hypothesis — the category-level outflow masks large dispersion between fund houses.**
The small-cap category recorded a ₹94 crore net outflow in March 2024. Nippon's two disclosed
schemes moved in opposite directions over the same month, with the restricted small-cap scheme
showing a far larger outflow than the entire category's net figure. If individual fund houses
took inflows while the category bled, the headline number conceals the more interesting story.
*Being tested across the full universe.*

---

## Data

| Source | What it provides | Coverage |
|---|---|---|
| AMFI daily NAV history | Daily NAV per scheme | 36.7M rows, 38,107 scheme codes, Apr 2006 – present |
| AMC stress test disclosures | Liquidation days, cash %, cap-segment split, investor concentration, beta, PE, turnover — and **monthly scheme-level AUM** | Feb 2024 onward, mid & small cap schemes only |
| AMC notice-cum-addenda | Restriction type, effective date, severity, reversal date | Compiled from primary filings across all 24 fund houses |

All sources are public regulatory disclosures. No paid or licensed data is used.

**On the NAV archive:** the historical data used here is a community mirror of AMFI's published
feed, cleaned on import — every NAV numerically typed, every date ISO-formatted across all 36.7
million rows. AMFI's own feed is not that tidy. The pipeline reads the mirror for historical
depth and goes directly to AMFI's source files for the analysis window, so ingestion handles
real input rather than pre-sanitised input.

The defects that matter are semantic, not structural: NAVs unchanged across consecutive trading
days, missing business days, Direct plans priced below their Regular counterparts when lower
expenses make that impossible, scheme codes that discontinue at mergers. Catching those requires
knowing what the numbers mean.

**On the addenda:** these are legal notices amending a scheme's Scheme Information Document, and
they are the authoritative record of what changed and when. Press reporting was checked against
them throughout and was wrong on several material points — including the effective date of at
least one restriction and the claim that a widely covered fund house had "first placed
restrictions in July 2023" when its own filings show an earlier episode. Where the two conflict,
the filing governs.

---

## Repository structure

```
sql/schema/     table, index and constraint definitions
sql/load/       seed data and bulk-load steps
sql/analysis/   the views and queries behind the findings above
scripts/        data acquisition and orchestration
```

The regulatory dataset lives in the database rather than in flat files: `core.study_universe`
holds the 24 scheme codes in scope, and `core.amc_restriction` holds every restriction event
compiled from the filings. Both are created and populated by the numbered files in `sql/`.

Each restriction row carries the issuing fund house, both dates, the addendum reference where
the filing has one, and a note recording anything the row alone would not convey.

---

## Reproducing this

Raw NAV data is not committed — the repository holds the code that builds the database, not the
database itself. Third-party PDFs are not redistributed; each restriction row identifies its
source filing by fund house, date and addendum reference.

*Setup instructions to follow once the ingestion layer is complete.*

---

## Scope and limitations

**The study universe is the 24 fund houses running an actively managed small-cap scheme**,
derived from AMFI scheme data rather than chosen by hand.

**All 24 archives were verified in full**, so an absence of restriction rows for a fund house
means a checked negative rather than an unchecked one. Had any archive been unreachable, that
fund house would have been marked unknown rather than defaulted into the control group — doing
otherwise would define the control group partly by website quality.

**Only three fund houses were restricted entering the event.** That is too few to establish a
group effect on the drawdowns, and the analysis says so rather than implying a test was run that
could have failed. The drawdown result is reported as a negative finding, supported by the
timing evidence.

**Two schemes cannot support a before-and-after comparison.** Baroda BNP Paribas Small Cap Fund
launched on 30 October 2023, four months before the event, and Mahindra Manulife's in December
2022. They appear in the regulatory dataset but are excluded from time-series analysis for want
of a baseline.

**Scheme codes were selected by hand, not by filter.** Matching scheme names for small cap
variants returns 210 rows over the study window for 24 target funds, and the archive uses ten
different conventions for what is the same plan and option. A filter that looks correct returns
24 rows whether or not they are the right 24, and nothing errors when they are not. The
selection and the specific cases where a plausible filter picks the wrong row are documented in
the schema files.

**Restriction parameters appear coordinated rather than independent.** Several fund houses
adopted identical caps, identical breach-handling language and identical carve-outs within weeks
of each other, which suggests a shared industry template. This weakens the assumption that each
fund house's decision was made independently, and is stated as a limitation rather than assumed
away.

**Scheme-level AUM is published quarterly by AMFI**, too coarse for a month-long event. The
stress test disclosures supply monthly AUM, but only for mid and small cap schemes and only from
February 2024. Where a question cannot be answered within those limits, it is documented as a
limitation rather than estimated around.

**NAV history is loaded from January 2022 onward**, giving roughly 26 months of pre-event
baseline. The archive extends to 2006; the earlier depth is not loaded because the event study
does not reach it. All 38,107 scheme codes are present in the loaded window, but scheme names
are parsed into a clean plan and option hierarchy only for the schemes the analysis touches. The remainder are
largely closed-ended fixed maturity plans that matured years before the event studied here. This
is a scope decision, not an omission.
