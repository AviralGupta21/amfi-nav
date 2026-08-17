# NOTES.md — Concepts, Vocabulary & Domain Knowledge

**Project:** Small-cap stress testing & AMC inflow restrictions (Feb–Mar 2024)
**Purpose:** Revision file. Everything here should be explainable out loud without notes.
**Last updated:** 17 August 2026

---

## PART 1 — THE FUNDAMENTALS

### What a mutual fund is
Many investors pool money into one pot. A professional manages it. Ownership is tracked
in **units**, not rupees, because people invest different amounts at different times.

### NAV (Net Asset Value)
The price of one unit.

    NAV = (value of everything the fund owns − what it owes) ÷ number of units

Example: fund owns ₹1 crore of stocks, 1 lakh units exist → NAV = ₹100.
Stocks rise 2% → pot is ₹1.02 crore → NAV = ₹102.

**Key principle: NAV changes ONLY when the value of the holdings changes.**

### AUM (Assets Under Management)
Total size of the pot.

    AUM = NAV × number of units

### Inflow / Outflow
- **Inflow** = new money in (subscriptions)
- **Outflow** = money withdrawn (redemptions)
- **Net flow** = subscriptions − redemptions

**Critical insight: a new investor does NOT change NAV.**
She pays the current NAV; the fund *creates* new units for her. Pot grows, unit count grows,
NAV per unit is unchanged. Units are created on the way in and destroyed on the way out.

So:
- **NAV moves** → because investments gained/lost value
- **AUM moves** → because of BOTH: investment performance AND people entering/leaving

### THE FLOW DECOMPOSITION (the most important analyst skill here)

If AUM grew 20%, you cannot tell whether the manager was good or the marketing was good.
Separate them:

    Expected AUM from performance alone = AUM_start × (1 + NAV return)
    Net flow ≈ AUM_end − [AUM_start × (1 + NAV return)]

**Worked example:**
- Start: AUM ₹2,000 cr, NAV ₹50 → 40 crore units
- End:   AUM ₹2,400 cr, NAV ₹55 → 43.64 crore units
- NAV return = 10%. Performance alone → ₹2,200 cr. Actual = ₹2,400 cr.
- **Net inflow ≈ ₹200 cr**

Cross-check via units: 3.64 crore new units × ₹55 ≈ ₹200 cr. Same answer.

So: fund grew 20% in size, but only 10% was skill. Half the growth was distribution.

**Caveat to state aloud:** this assumes money arrived at end-of-period. In reality it
trickles in at varying NAVs. Computing monthly instead of annually reduces this error.

### THE FOUR-LEVEL HIERARCHY (what the scheme dimension is built on)

One "fund" in conversation is actually four nested things in the data:

**1. Fund house (= AMC = Asset Management Company)** — the company. Nippon India, SBI, Kotak.
"Fund house" is the informal word; "AMC" is the formal one. One AMC runs many schemes.

**2. Scheme** — the actual product with its own portfolio and its own manager.
"Small Cap Fund", "Bluechip Fund", "Liquid Fund".

**3. Plan — DIRECT or REGULAR.** Same portfolio, same manager, **two different NAVs.**
- **Regular** pays a commission to whoever sold it to you, taken out of the expense ratio
- **Direct** was bought straight from the AMC — no middleman, lower expenses
- Identical holdings, but **Direct's NAV grows faster** because less is being skimmed

*→ This is the single biggest reason two rows can look like the same fund with different NAVs
and both be correct.*

**4. Option — GROWTH, IDCW, or BONUS.** Again same portfolio, different NAV path.
- **Growth** compounds everything back into the fund
- **IDCW** (Income Distribution cum Capital Withdrawal) pays out periodically, so its
  **NAV drops on payout dates**. Called **"Dividend"** before SEBI's 2021 rename — both words
  appear in the data depending on vintage
- **Bonus** — a third option type, observed in the archive
- IDCW further splits into **Payout** and **Reinvestment** variants

⚠️ **THE CLEAN FOUR-LEVEL MODEL IS AN OVERSIMPLIFICATION.** Verified against real data
(17 Aug 2026) — see the parsing pathology catalogue in Part 11. What actually exists:

| Level | Observed values |
|---|---|
| Plan (modern) | `Direct`, `Institutional`, **or nothing at all** |
| Plan (legacy, pre-2013) | `Growth Plan`, `Dividend Plan` — sits *between* modern plan and option |
| Option | `Growth`, `IDCW` / `Dividend`, `Bonus` |

🔴 **REGULAR IS ENCODED AS ABSENCE.** The string "Regular" does not appear. A scheme is Regular
because it is *not* Direct and *not* Institutional. **You cannot detect it with a keyword** —
only by ruling everything else out.

🔴 **Two plan layers stack.** `Direct Plan Growth Plan` means modern-plan=Direct AND
legacy-plan=Growth. The word "Plan" appears twice meaning different things, and in
`Growth Plan - Growth Option` the word "Growth" appears twice at two different levels.
**Position disambiguates. Keywords cannot.**

**So one scheme becomes many rows:**
```
SBI Small Cap Fund - Direct Plan  - Growth
SBI Small Cap Fund - Direct Plan  - IDCW
SBI Small Cap Fund - Regular Plan - Growth
SBI Small Cap Fund - Regular Plan - IDCW
```
Same underlying portfolio. Different NAVs. All correct.
**This is much of why the archive holds 38,107 distinct scheme codes** (measured — see Part 11).

⚠️ **The hierarchy is real and structural. The NAME STRING is an unreliable narrator of it.**
Naming was never standardised — each AMC named its schemes however it liked, over decades, and
AMFI passes them through as-is. Splitting a name on its separator gives three pieces for one row,
five for the next, two for something from 2009. Expect:
- Plan sometimes stated, sometimes omitted entirely
- "Direct Plan" vs just "Direct"
- Separators varying — hyphen, en-dash, sometimes nothing
- Option sub-variants ("IDCW Payout", "IDCW Reinvestment") splitting one field into two pieces
- Unplanned tokens — "(erstwhile XYZ Fund)", "Segregated Portfolio 1", "Bonus Option"

*→ Reconstructing a clean hierarchy from messy text IS the reconciliation work (D2).*

### 🔴 DIRECT PLANS DID NOT EXIST BEFORE JANUARY 2013
The archive starts **2006-04-01**. Direct plans were introduced in **January 2013**.

So for roughly the first seven years of the data, **every scheme has only a Regular plan** —
no Direct counterpart exists to compare against.

**Consequence for the reconciliation layer:** any Direct-vs-Regular check will find nothing
before 2013. Written naively it either returns zero rows and looks broken, or worse, silently
supports a false conclusion about the pre-2013 period. **The check must be date-bounded, and the
bound has a domain reason, not an arbitrary one.**

*→ Exactly the class of semantic check D21 describes.*

### NAV per unit says NOTHING about whether a fund is good
₹15 NAV vs ₹150 NAV is an artifact of launch date and starting price. ₹10,000 buys 666 units
of one or 66 of the other — identical exposure. Only forward *return* matters.
(AUM size isn't a quality signal either — it mostly measures distribution reach.)

---

## PART 2 — LIQUIDITY & THE SMALL-CAP PROBLEM

### Liquidity
How easily something can be sold without moving its price.
- Large company (e.g. Reliance): sell ₹100 cr this afternoon, no problem.
- Small company: few buyers exist. Selling ₹100 cr means dropping your price to find takers,
  and the price collapses as you sell.

### Why a large small-cap fund is dangerous
A ₹40,000 cr fund holding hard-to-sell shares. If many investors redeem at once:
1. Fund must sell to raise cash
2. Selling crashes the prices of its own holdings
3. **First-mover advantage:** early redeemers get paid at good prices; those who stay
   absorb the damage
4. This is a run

**Funds generally cannot borrow to meet redemptions** — that's a regulatory restriction,
not a choice. Their options are: hold cash in advance, sell into a falling market, or
in extreme cases gate redemptions (as in the Franklin Templeton debt fund episode, 2020).
The absence of a borrowing escape hatch is exactly why underlying liquidity matters so much.

---

## PART 3 — ARBITRAGE FUNDS (secondary chapter)

### Spot vs Futures
- **Spot market:** buy the share right now, e.g. ₹200
- **Futures contract:** agreement to transact on a fixed future date (e.g. last Thursday of
  the month), e.g. ₹203

The gap exists because paying later has value (you keep your cash meanwhile). This is the
**cost of carry**. It is normal and largely predictable.

### The two-legged trade — do BOTH, simultaneously
1. **BUY** the actual share in spot at ₹200 (fund now owns it)
2. **SELL** a futures contract at ₹203 (fund has committed to *deliver* the share and
   *receive* ₹203)

₹3 is locked in immediately. Price movement is irrelevant.

**Worked example — stock crashes to ₹150 before expiry:**
- The share it owns: bought 200, now worth 150 → **−₹50**
- The futures contract: promised to sell at 203 when it's worth 150 → **+₹53**
- **Net = +₹3.** Exactly what was locked in.

**The mental picture to hold:** the fund OWNS the share AND has ALREADY SOLD it forward.
Every price outcome nets to ₹3. Common error: thinking the fund "pays" ₹203 — it *receives* ₹203.

### Why arbitrage funds exist commercially
Returns resemble a savings-type product, but ≥65% sits in equity, so they get **equity tax
treatment** rather than debt treatment. Highly attractive to high-tax-bracket investors.
This is why the category grew to ~₹3.5 lakh crore.

### Why costs hurt them disproportionately
Profit is ~₹3 on ₹200 = ~1.5%. Two compounding reasons:
- **High frequency:** contracts are rolled every expiry — many taxable transactions per year
- **Thin margin:** a cost rise that's a rounding error against a 15% equity return is a
  serious bite out of 1.5%

A large-cap fund buys and mostly sits. An arbitrage fund is in and out constantly.

---

## PART 4 — MARKET VOCABULARY

**Index** — a basket of stocks tracked as one number (e.g. Nifty Smallcap 100 = 100 leading
small companies). A thermometer for a market segment. Not directly purchasable.

**"Froth"** — deliberately informal, not technical. Prices have risen more than the underlying
businesses justify; people are buying because prices are rising. Softer than "bubble."
When a regulator uses it publicly, it signals concern without shouting "crash."

**Net outflow** — subscriptions minus redemptions. ₹94 cr net outflow might mean ₹5,000 cr in
and ₹5,094 cr out. It's a balance, not a gross figure.

**Return channel vs flow channel** — the core analytical distinction:
- *Return channel:* holdings changed value → NAV moves
- *Flow channel:* investors entered/left → AUM moves, NAV doesn't

Every event reaches a fund through one or both of these. Always ask which.

---

## PART 5 — THE STRESS TEST PARAMETERS

Mandated by SEBI via AMFI. **The unifying question behind all seven:**
*if everyone wants out at once, what happens?*
Each parameter is a different angle on that one question.

### 1. Days to liquidate 25% / 50% of the portfolio
"How long to sell a quarter / half of everything without wrecking prices?"
Observed range across funds: ~3 days to 50+ days. Higher = more trapped.

- **"Pro-rata"** = sell proportionally, not cherry-picked. Without this rule a fund could dump
  its easy-to-sell holdings first and post a flattering number — leaving remaining investors
  holding only the illiquid junk. Pro-rata forces the honest answer and enforces equal
  treatment of unitholders.
- **"Excluding the 20% most illiquid holdings"** = a concession to reality. Every small-cap
  fund owns some effectively unsellable positions; including them makes every answer
  "infinity." Excluding them makes funds comparable **at the cost of understating true risk.**

  *→ Interview point: knowing this limitation shows you read the methodology, not just the number.*

### 2. Top-10 investor concentration
Share of the fund owned by its ten largest investors. If ten investors hold 40% and two leave,
the fund must liquidate a huge chunk overnight. Ten lakh retail investors never move in unison;
ten institutions might. **Concentration = fragility.**

### 3. Standard deviation
How much returns bounce around their own average. Two funds averaging 12%:
one delivers 11/13/12/12, the other −20/+45/−5/+28. Same average, completely different experience.
Higher = bumpier.

### 4. Beta
Movement *relative to the market*. Beta 1.0 = moves with market. 1.3 = market drops 10%,
expect ~13%. 0.7 = expect ~7%.
**Std dev = total bounciness. Beta = bounciness caused by the market specifically.**
A fund can have high std dev and low beta if it's volatile for its own idiosyncratic reasons.

### 5. Trailing P/E (Price-to-Earnings)
Company earns ₹10/share, share costs ₹250 → P/E = 25. You pay ₹25 for each ₹1 of annual profit.
Roughly: years of current earnings to pay back the price.
- **Trailing** = last 12 months of *actual* earnings (fact)
- **Forward** = analyst forecasts (opinion)

High P/E = either rapid growth expected, or overpaying. **This number IS the "froth" argument,
which is precisely why the regulator wanted it disclosed.**

### 6. Portfolio turnover
How much of the portfolio is bought/sold in a year. 100% ≈ whole portfolio replaced once.
20% ≈ manager mostly sits still.
Implications: (a) high turnover = high transaction costs eating returns; (b) signals manager
style — active trader vs long-term holder; (c) hints at how fast they can reposition in a crisis.

### 7. Large / Mid / Small / Cash split — "dry powder"
A small-cap fund isn't 100% small-caps. Rules require ≥65% in small-caps; the remaining ~35%
is the manager's choice — larger companies or cash.

**Cash is the most interesting variable in the whole disclosure.** It looks like laziness in a
rising market (earns nothing), but does two jobs when things go wrong:
1. **Pays redemptions without forced selling.** Investor wants ₹100 cr? Pay from cash. No selling,
   no price damage, no harm to remaining investors. This is the exact trap the stress test was
   built to expose — and cash is the escape hatch.
2. **Ammunition.** Prices crash, everything is cheap, the manager holding cash can buy while
   others are forced sellers.

**"Dry powder"** — from muskets: gunpowder kept dry so you can actually fire when the moment comes.

*→ Testable hypothesis for the project: did funds holding more cash in February handle the
March correction better?*

---

## PART 6 — THE EVENT (Feb–Mar 2024)

⚠️ **All dates below are from news reporting and still need primary-source confirmation.**

### Timeline
| Date | Event |
|---|---|
| Feb 2024 | Nifty Smallcap 250 up ~71% over prior 52 weeks; Nifty Midcap 100 up ~64% vs Nifty ~28% |
| **27 Feb 2024** | AMFI letter to AMCs: **moderate inflows** into small/midcap funds (following SEBI communication). Not publicly disclosed at the time |
| **28 Feb 2024** | AMFI letter: **stress test + risk disclosure requirements** |
| Early Mar 2024 | SEBI chair Madhabi Puri Buch's "froth" comments → smallcap index plunged ~9% |
| **15 Mar 2024** | First stress test disclosure deadline; every 15 days thereafter |
| March 2024 | Nifty Smallcap 100 fell ~13% over the month |
| March 2024 | **First net outflow in the smallcap category in 30 months: ₹94 crore** |
| Early Apr 2024 | Index rebounded ~11% in nine consecutive sessions |
| **2 Jul 2024** | Kotak MF resumed lumpsum AND SIP into its small-cap fund |

### Why the two-letter structure matters
- **27 Feb = behavioural trigger** (AMCs told to restrict flows)
- **28 Feb / 15 Mar = disclosure trigger**

Four days apart, but **different interventions.** Treating them as one event muddles the story.

### Why ₹94 crore is the headline number
The *size* is trivial against a category holding lakhs of crores. The **sign flip** is what matters —
30 straight months of inflows, then reversal. First hard evidence retail sentiment turned.

### AMC responses (confirmed so far — needs primary-source verification)
Nippon (restricted from Jul 2023; tightened Mar 2024 — daily SIP cap cut ₹5 lakh → ₹50,000,
exit load changed 1 month → 1 year), Tata, SBI, Kotak, ICICI Prudential, Franklin Templeton
(lumpsum capped ₹2 lakh/month, SIP ₹50,000/month), Motilal Oswal (exit load change).

**Not binary — at least four distinct restriction types:**
1. Lumpsum suspension
2. Lumpsum cap
3. SIP cap
4. Exit load change

Some AMCs stacked several. This is richer than a simple treated/untreated split.

**Why this event was chosen:** AMCs faced the same rule on the same date and made *different,
publicly documented* choices. That's a natural experiment in management behaviour — and it
directly answers "why did one company do better than another?"

---

## PART 7 — METHODOLOGY

### The four filters for a usable event
1. **Sharp, known date.** "Market got volatile in Q3" is not an event. "Rule effective from
   date X" is.
2. **Definable treated set.** State which schemes should be affected *before* looking at data.
   Otherwise you're pattern-hunting.
3. **A control group.** ← the part almost everyone skips. If small-cap returns changed after
   the event, so what — maybe everything changed. You need a comparable group that shouldn't
   have been affected, to subtract out what was happening to everyone.
   Treated-vs-control × before-vs-after = **difference-in-differences**.
4. **Visible in data you actually have.**

### Variable roles in this project
| Role | Source |
|---|---|
| **Outcome** (what you measure) | NAV and AUM — drawdown depth, recovery speed, flow reversal |
| **Treatment** (what splits the groups) | AMC restriction table — restricted vs not, and which type |
| **Explanatory** (why they differed) | Stress test parameters + fund size, fund house, expense ratio, pre-event volatility from NAV history |

**Timing problem — RESOLVED (17 Aug 2026).** The original concern was that the first disclosure
came *after* the correction began, so the parameters could only explain the recovery phase.

**A 29-Feb-2024 file exists and contains real data** (Part 10). There is a genuine pre-event
baseline, so the strong before/after question is available: *did funds that looked more fragile
on 29 Feb fall harder in March?*

### Data quality > modelling
EDA is commoditised — anyone can generate a heatmap in ten minutes. What survived that
commoditisation is **data engineering rigour**: ingestion, schema design, reconciliation,
handling data that arrives broken. This is what AMC data teams actually do all day.

### The honesty principle
It is very easy to find a difference and invent a story for it. Markets are noisy; many things
happen at once. **Name your own confounders.** An interviewer at a rules-based shop will trust
"I found a 40bp divergence but can't cleanly separate it from the rate move that month" far more
than a confident causal claim.

---

## PART 8 — DATA SOURCES

| Data | Source | Status |
|---|---|---|
| Daily NAV | AMFI `DownloadNAVHistoryReport_Po.aspx` (accepts date range); AMFI NAV download page **caps at 90 days per request**; GitHub archive `captn3m0/historical-mf-data` (SQLite, full history, AMFI's own export format) | ✅ Solved |
| Scheme-wise AAUM | AMFI, **quarterly only** | ✅ Available, coarse |
| Monthly category flows | AMFI monthly reports | ✅ Available |
| Stress test disclosures | AMC websites — **confirmed archived back to March 2024** (see Part 10) | ✅ **VERIFIED 17 Aug 2026** |
| **Monthly scheme-level AUM** (mid/small cap only) | Column B of the stress test files | ✅ **Unexpected win — see Part 10** |
| AMC restriction addenda | Each AMC's own "addenda"/"notices" page | ⚠️ To be built manually |

### ⚠️ AMFI data defects — NOT PRESENT IN THIS ARCHIVE (verified 17 Aug 2026)
AMFI's **published** feed contains genuine defects — invalid ISINs (`NOTAPP`, `NA`, `IINF`
prefix, lowercase) and non-numeric NAV values (`#N/A`, `#DIV/0!`, `N.A.`, `B.C.`).

**But the `captn3m0` SQLite archive has been cleaned.** Verified: `typeof(nav)` returns `real`
for all 36,765,864 rows, `typeof(date)` returns `text` for all 36,765,864 rows. **One group each,
zero exceptions.** Real regulatory data is never this uniform — the maintainer stripped bad
values on import.

*→ An earlier version of this file called these defects "a gift for the reconciliation layer."
That was wrong for this source. See D21 for the resulting design change.*

### Constraint that shapes the whole project — NOW PARTLY LIFTED
AMFI gives daily NAV free and complete. It does **NOT** give daily scheme-level AUM — only
quarterly AAUM plus monthly category-level flows.

**However (17 Aug 2026):** the stress test files carry **monthly scheme-level AUM** for
mid and small cap schemes from March 2024 onward. For the treated group in this project,
monthly AUM is available. See Part 10.

*→ Interview line: "I scoped the question to what the public data could actually support."*

### Cadence note — RESOLVED (partly)
Original mandate was disclosure by 15 March 2024 and **every 15 days thereafter**.
Nippon's actual filenames are **monthly** from the start (`Risk-Parameters-Apr-2024.xls`,
`-May-2024`, `-Jun-2024`) — one file per month, no mid-month files.

**Updated 17 Aug 2026 with the observed file dates:** 29-Feb-2024 → 31-Mar-2024 → Apr → May → Jun.
No mid-month files exist at all. This reads as **month-end data disclosed with a lag** — the
29-Feb-data file published by the 15 March deadline — rather than fortnightly disclosure.

**This is a documented gap between what news reporting said was mandated ("every 15 days") and
what was actually published (monthly).** Worth stating carefully: the discrepancy may be in the
reporting rather than in Nippon's compliance. Check AMFI's actual 28 Feb letter wording if it
can be found.

*→ This is exactly the kind of detail that only surfaces from primary sources (D8).*

---

## PART 9 — OPEN QUESTIONS / GAPS

- [x] **Can the 15 March 2024 stress test disclosure be retrieved?** → **YES.** Nippon's archive
      runs back to March 2024. Files are `.xls`, URL pattern fully predictable. Resolved 17 Aug 2026
- [x] **Is the 27 Feb 2024 AMFI letter public?** → Confirmed to exist via Reuters / Business
      Standard reporting; the letter itself was **not publicly disclosed**. Cite as news-sourced
- [x] **When did the cadence change from fortnightly to monthly?** → Nippon's files are monthly
      from the start. See the cadence note in Part 8. Sub-question still open (below)
- [x] **Is there a mid-March file?** → No. Files run 29-Feb → 31-Mar → Apr → May → Jun.
      Month-end data, disclosed with a lag
- [x] 🔴 **Does the 29-Feb-2024 file contain real data or a blank template?** → **REAL DATA.**
      Clean pre-event baseline confirmed. Also carries AMFI Scheme Code and an explicit
      portfolio date, both absent from later files
- [ ] 🔴 **PRIORITY: what does AMFI code 100377 resolve to in the NAV data** — a single
      plan/option, or the whole scheme? Determines whether the join is valid (Part 10)
- [ ] 🔴 **Run the March 2024 flow decomposition on 100377 and 113177.** Did Nippon take
      inflows during the crash while the category saw net outflows? (Finding 2, Part 10)
- [ ] Confirm the volume-collapse explanation for rising liquidation days — is NSE/BSE
      March 2024 volume data available to verify it directly?
- [x] **Why did Small Cap liquidation days stay flat while AUM grew 23%?** → Answered by the
      March file: the metric tracks market volumes, not just fund size
- [ ] Do the other 11 AMCs archive back to Feb 2024? (Assume nothing about URL conventions —
      Nippon used three in four months)
- [ ] Exact wording of the AMFI 28 Feb letter on cadence — was "every 15 days" accurate reporting?
- [x] 🔴 **What is stored in `nav.date`?** → **TEXT**, uniformly, all 36.7M rows.
      ⚠️ Format still unchecked — see below
- [x] 🔴 **What FORMAT are the date strings in?** → **`YYYY-MM-DD`** (ISO 8601).
      Postgres parses natively. No load specification needed
- [x] 🔴 **Do the documented AMFI defects survive in this archive?** → **NO.** `typeof(nav)`
      is `real` for all rows. Archive is pre-cleaned. **Design changed — see D21**
- [ ] What do the integer values in `securities.type` mean? Undocumented
- [x] **Are the foreign keys enforced / any orphaned `scheme_code` values?** → **0 orphaned NAV
      rows; 606 schemes with no NAV.** Containment confirmed both ways (Part 11)
- [ ] What are the 606 schemes with no NAV rows? Never-launched NFOs, withdrawn schemes, or
      something else? Sample the names
- [ ] How many of the 38,107 codes are dead FMPs? Determines whether the scheme dimension needs
      a relevance filter before parsing
- [ ] Exact effective dates for each AMC restriction — from AMC addenda, not news articles


---

## PART 10 — THE STRESS TEST FILES (verified 17 Aug 2026)

### Source and URL patterns — NOT PREDICTABLE
Nippon: Investor Service → Downloads → Factsheet, Portfolio and Other Disclosures.

**Three different naming conventions observed in four consecutive months:**

| File | Convention |
|---|---|
| `/FactsheetsDocuments/Risk-Parameters-Jun-2024.xls` | plural, `Mon-YYYY` |
| `/FactsheetsDocuments/Risk-Parameters-May-2024.xls` | plural, `Mon-YYYY` |
| `/FactsheetsDocuments/Risk-Parameters-Apr-2024.xls` | plural, `Mon-YYYY` |
| `/FactsheetsDocuments/Risk-Parameter-Mar-31-2024.xls` | **singular**, `Mon-DD-YYYY` |
| `/Risk%20Parameters/Format%20for%20disclosure%20of%20Risk%20Parameters%2029-Feb-2024_.xlsx` | **different folder**, different filename, `.xlsx`, trailing underscore |

⚠️ **METHOD CORRECTION (17 Aug 2026):** an earlier note in this file claimed the pattern was
"fully predictable" and that the archive could be fetched by constructing URLs. **That was wrong** —
it was extrapolated from two files in adjacent months. **Scrape the `href` attributes off the
page instead of constructing URLs.** Apply this to all AMCs.

*→ Interview point: this is a live example of why you verify a pattern across the full range
rather than confirming it twice and generalising.*

⚠️ **Page-label trap:** only the most recent entry is labelled "(Data as on 30th June 2024)".
Older entries on the page are **undated** and read identically. They are *not* mid-month files —
they are previous months. Always confirm by the URL, not the page text.

### ✅ PRE-EVENT BASELINE CONFIRMED — 29 Feb 2024 file (verified 17 Aug 2026)
`Format for disclosure of Risk Parameters 29-Feb-2024_.xlsx` contains **real Nippon data**,
not a blank template. Title inside: *"Format for disclosure of Stress Test & Liquidity Analysis."*

**This is a genuine pre-event snapshot** — before the froth comments, before the March correction.
The timing caveat in Part 7 no longer applies. The strong question is now available:
*did funds that looked more fragile on 29 Feb fall harder in March?*

**Two columns present here that are ABSENT from the Apr/May/Jun files:**

| Col | Field | Why it matters |
|---|---|---|
| **A** | **AMFI Scheme Code** (100377, 113177) | 🔑 **THE JOIN KEY** to NAV data. Integer join instead of matching on fund names |
| **B** | **As of (Portfolio date)** = 29-Feb | Authoritative date stated *inside* the file, not inferred from the filename |

⚠️ **Format drift — the FEBRUARY file is the outlier.** Nippon's Feb file has scheme code +
as-of date. The **Mar, Apr, May and Jun files all lack both** and start at Scheme Name.
The rich format existed once and was dropped immediately.

**Consequence:** the join key is available for exactly one period. For every other month the
scheme must be matched by **name**, which is the unreliable route. → Build a scheme-code
lookup **from the Feb file**, then reuse it to key every later file by name-to-code mapping.
That mapping table is itself a deliverable of the reconciliation layer.

### 🔴 JOIN GRANULARITY TRAP — test before trusting the join
AMFI scheme codes are normally **per plan AND option** (Direct-Growth ≠ Regular-IDCW).
But this file gives **one code per scheme** next to AUM of ₹24,493.62 cr — which is almost
certainly the total across **all** plans and options.

**So the code may point at a single plan while the AUM covers all of them.**
→ Look up 100377 in the NAV data. If it resolves to one plan, a naive join attributes
whole-scheme AUM to one share class. Textbook reconciliation error — exactly what D2 exists to catch.

### Stress test methodology (from the file's own Note section — authoritative)
- 3-month daily average traded volumes on **both NSE and BSE**
- **PV = Participation Volume**; liquidation assumes 10% PV with 3x volumes
- Bottom 20% of portfolio by scrip liquidity is **removed** before calculating
- The 20% *least liquid* securities are ignored
- Cash is assumed to be used on a **pro-rata** basis
- Pro-rata selling is **not** actually mandatory for AMCs — it is assumed for the test
  specifically to ensure equal treatment of all investors
- Large/Mid/Small cap classification per the **AMFI published list**
- Std Dev, Beta and Turnover per AMFI Best Practice Circulars **61 and 64**,
  dated 14-Sep-2015 and 29-Oct-2015

*→ Quote this methodology from the file itself, not from news paraphrase.*

### What's in the file
Two schemes only for Nippon — **Nippon India Growth Fund** (mid cap) and **Nippon India Small
Cap Fund**. The mandate covered mid and small cap only, so every AMC's file will be similarly short.
**Estimated total: 12 AMCs × ~30 months × ~2 rows = a few hundred rows.** Small data, ugly format.

**Columns (A–O labelling is the file's own):**

| Col | Group | Field |
|---|---|---|
| A | — | Scheme Name |
| B | — | **AUM (Rs. Cr)** ← the unexpected win |
| C, D | Stress Test | Days to liquidate 50% / 25% portfolio, pro-rata after removing bottom 20% by scrip liquidity (10% PV with 3x volumes) |
| E | Concentration | Top 10 investor (liability side) |
| F–I | Concentration | Asset side (AUM held in): Large Cap %, Mid Cap %, Small Cap %, **Cash %** |
| J, K | Volatility | Portfolio annualised std dev %, Benchmark annualised std dev % |
| L | Volatility | Portfolio Beta |
| M | Valuation | Portfolio Trailing 12m PE |
| N–P | Valuation | Benchmark PE — Trailing 12m, 1 year, 2 year |
| Q | Valuation | Portfolio Turnover Ratio |

### Format problem
- **`.xls`** (old binary), not `.xlsx`
- **Multi-row merged headers** — rows 1–4, with group headers spanning columns, then a row of
  lettered labels. **Data starts at row 5**
- Not `\copy`-able. Headers must be flattened into single column names first
- Every AMC will lay this out slightly differently

*→ This is the heterogeneous-format problem from D3, arriving in v1 rather than v2.*

### THE UNEXPECTED WIN — monthly scheme-level AUM
Column B gives **monthly AUM per scheme from March 2024 onward**. Combined with daily NAV,
the flow decomposition becomes computable **monthly at scheme level** for exactly the funds
this project is about.

    Net flow ≈ AUM_end − [AUM_start × (1 + NAV return)]

**Live example from the two files already downloaded (Nippon India Growth Fund):**
- 31 May 2024: AUM ₹27,946.07 cr
- 30 June 2024: AUM ₹30,841.28 cr
- Growth = **+10.4%**
- **How much was performance and how much was inflow? NAV data answers it.**

*→ This is the first real analysis and it is runnable immediately.*

### Observed values — Feb (pre-event) / Mar (correction) / Jun (recovery)

**Nippon India Growth Fund** (mid cap, AMFI code 100377)
| Metric | 29 Feb | 31 Mar | 30 Jun |
|---|---|---|---|
| AUM (₹ cr) | 24,493.62 | 24,796.00 | 30,841.28 |
| Days to liquidate 50% / 25% | 7 / 4 | 8 / 4 | 6 / 3 |
| Top 10 investor % | 1.54 | 1.51 | 1.54 |
| Large / Mid / Small / Cash % | 18.40 / 66.71 / 13.53 / 1.36 | 18.92 / 66.44 / 13.43 / 1.22 | 17.91 / 66.93 / 13.66 / 1.50 |
| Std dev % | 13.79 | 13.96 | 14.38 |
| Beta | 0.88 | 0.86 | 0.89 |
| Trailing 12m PE | 35.19 | 30.23 | 34.32 |
| Turnover | 0.15 | 0.22 | 0.22 |

**Nippon India Small Cap Fund** (AMFI code 113177)
| Metric | 29 Feb | 31 Mar | 30 Jun |
|---|---|---|---|
| AUM (₹ cr) | 46,029.84 | 45,248.33 | 56,471.68 |
| Days to liquidate 50% / 25% | 27 / 13 | **29 / 15** | 26 / 13 |
| Top 10 investor % | 0.91 | 0.76 | 0.71 |
| Large / Mid / Small / Cash % | 13.46 / 14.65 / 67.49 / 4.40 | 13.05 / 14.51 / 68.38 / 4.06 | 9.99 / 13.88 / 72.04 / 4.09 |
| Std dev % | 14.76 | 14.48 | 14.77 |
| Beta | 0.76 | 0.75 | 0.75 |
| Trailing 12m PE | **41.91** | **31.65** | 32.06 |
| Turnover | 0.18 | 0.22 | 0.25 |

### 🔑 FINDING 1 — liquidity evaporates exactly when it's needed
Small Cap AUM **fell** 46,030 → 45,248 (−1.7%) in March, yet days to liquidate 50% **rose**
27 → 29, and 25% rose 13 → 15.

A smaller portfolio should be *easier* to sell. It got harder because liquidation days depend on
portfolio size **and market trading volumes** — and volumes dried up during the correction.

**This is the core insight the stress test was designed to expose, visible in two columns.**

It also resolves the June puzzle: by June AUM was up 23% but days had fallen to 26, because
volumes had recovered. **The metric tracks market conditions at least as much as fund size.**

### 🔑 FINDING 2 (HYPOTHESIS) — Nippon may have taken inflows during the crash
- Small Cap AUM fell only **1.7%** in a month when small-caps fell far more
- Growth Fund AUM actually **rose 1.2%**

If NAV dropped meaningfully while AUM barely moved, the gap must be new money.

**Test:** run the decomposition on schemes 100377 and 113177 for March 2024.

    Net flow ≈ AUM_end − [AUM_start × (1 + NAV return)]

Requires the March 2024 NAV return from the historical archive.

**Why it matters:** the category-level headline was a ₹94 cr net **outflow** in March. If Nippon
individually took **inflows**, the category number is masking large dispersion between fund houses —
some bleeding, some gaining.

**That dispersion is the project's actual finding.** It is the "why did one company do better than
another" question this event was chosen for (D5).

⚠️ **Hypothesis, not a conclusion.** It has a specific test and the test has not been run.

### Other March observations
- Trailing PE collapsed on both: Small Cap 41.91 → 31.65, Growth 35.19 → 30.23. **Froth deflating**
- Turnover jumped on both (0.18 → 0.22 and 0.15 → 0.22) — managers traded materially more
  during the stress
- Top-10 investor concentration fell on both — consistent with larger investors exiting

---

## PART 11 — THE NAV ARCHIVE SCHEMA (inspected 17 Aug 2026)

Source: `captn3m0/historical-mf-data`, release artifact `funds.db.zst` → SQLite.

### Three tables, normalised

```sql
CREATE TABLE nav (
    scheme_code INTEGER,
    date,                      -- ⚠️ NO DECLARED TYPE
    nav FLOAT,
    FOREIGN KEY (scheme_code) REFERENCES schemes(scheme_code)
);

CREATE TABLE schemes (
    scheme_code INTEGER PRIMARY_KEY,
    scheme_name TEXT
);

CREATE TABLE securities (
    isin TEXT UNIQUE,
    type INTEGER,
    scheme_code INTEGER,
    FOREIGN KEY (scheme_code) REFERENCES schemes(scheme_code)
);
```

Plus one view: `nav_by_isin` — joins `nav` to `securities` on `scheme_code`.
**Indices (0)** — none ship with the file; they must be created after decompressing.

### ✅ Finding 1 RESOLVED — `date` is uniformly TEXT, format ISO 8601
`typeof(date)` → `text` for all **36,765,864** rows. One group, zero exceptions.

**Format confirmed: `YYYY-MM-DD`** (e.g. `2013-05-03`). ISO 8601 — **PostgreSQL parses this
natively**, no explicit format specification needed, no day/month ambiguity. Best case outcome.

⚠️ Sampled via `LIMIT 10` with no `ORDER BY`, which returns physical storage order, not
chronological order. **The values seen do not indicate the start of the date range** —
run `MIN(date)` / `MAX(date)` for that.

### ✅ Finding 2 RESOLVED — the archive is CLEAN, defects removed
`typeof(nav)` → `real` for all **36,765,864** rows. One group, zero exceptions.

**The documented AMFI defects are absent from this archive.** They describe what AMFI *publishes*,
not what survives the maintainer's import. See Part 8 and D21.

### Baseline figures (measured 17 Aug 2026)
| Metric | Value |
|---|---|
| Total NAV rows | **36,765,864** |
| Date range | **2006-04-01 → 2026-08-16** (~20.4 years, current to yesterday) |
| `typeof(date)` distinct values | 1 (`text`, ISO 8601) |
| `typeof(nav)` distinct values | 1 (`real`) |

### ⏱️ INDEX IMPACT — measured before and after (17 Aug 2026)

**Index build cost (run individually):**
| Index | Build time |
|---|---|
| `idx_nav_date_scheme` on `nav(date, scheme_code)` | 29,173 ms |
| `idx_nav_scheme_code` on `nav(scheme_code)` | 25,774 ms |
| `idx_securities_scheme_code` | 42 ms |
| `idx_securities_isin` | 31 ms |
| **Total** | **~55 seconds** |

**Query performance:**
| Query | Before | After | Speedup |
|---|---|---|---|
| `schemes LEFT JOIN nav` (606 rows) | 453,207 ms | 2,545 ms | **178×** |
| `COUNT(*) WHERE scheme_code = 100377` | 4,181 ms | 24 ms | **174×** |
| `ORDER BY date DESC LIMIT 10` | 5,434 ms | 13 ms | **418×** |
| `COUNT(DISTINCT scheme_code)` from `nav` | 8,978 ms | 1,509 ms | **6×** |
| `typeof(date)` grouped, full table | 19,559 ms | — | not re-run |
| `typeof(nav)` grouped, full table | 16,449 ms | — | not re-run |

**Economics: 55 seconds to build all four. The first query alone saved 450 seconds.**
Paid for itself on first use.

### 🔑 WHY ONE QUERY ONLY GOT 6× — the rule that generalises
Three queries improved 100–400×. One improved 6×. The difference is **selectivity**.

- **Selective queries narrow** — find one scheme, find the top ten dates, match rows one at a
  time. An index turns each into a jump straight to the answer, skipping nearly everything
- **`COUNT(DISTINCT scheme_code)` does not narrow.** It must visit every scheme code that exists.
  The index still helps — scanning a structure containing only `scheme_code` beats scanning full
  rows with dates and NAVs attached — but all 36.7M entries are still touched

**Rule: indexes are transformative for selective queries and merely helpful for full aggregations.**

*→ This applies directly in PostgreSQL and explains why one query is fast while a similar-looking
one is not.*

### 🔎 EXPLAIN QUERY PLAN — verified (17 Aug 2026)

| Query | Plan | Speedup |
|---|---|---|
| `COUNT(*) WHERE scheme_code = 100377` | **SEARCH** nav USING COVERING INDEX | 174× |
| `schemes LEFT JOIN nav` | SCAN s + **SEARCH** n USING COVERING INDEX | 178× |
| `ORDER BY date DESC LIMIT 10` | **SCAN** nav USING COVERING INDEX | 418× |
| `COUNT(DISTINCT scheme_code)` | **SCAN** nav USING COVERING INDEX | 6× |

**No `USE TEMP B-TREE FOR ORDER BY` anywhere** — the composite index serves the sort directly.

### Reading the plan output correctly
| Output | Meaning |
|---|---|
| `SCAN <table>` alone | No index. Full table read. **Bad** |
| `SCAN <table> USING INDEX` | Index read start-to-finish in order. Often optimal |
| `SEARCH <table> USING INDEX` | Jumping straight to matching rows. Best case |
| `USING COVERING INDEX` | Index holds every column the query needs — **the table is never opened** |
| `USE TEMP B-TREE FOR ORDER BY` | Sort could not use an index; done in memory. **Warning sign** |

*The word that matters is `INDEX`, not `SCAN` vs `SEARCH`.*

### 🔑 REFINED RULE — `SCAN` does not mean "reads everything"
Both bottom queries are `SCAN`, yet one got **418×** and the other **6×**. The difference is
the `LIMIT`.

- Query 3 scans the index in date order and **stops after ten entries**
- Query 4 has no stopping condition, so it walks all 36.7M

**`SCAN` means "reads in order." Whether that is cheap depends on whether something lets it
stop early.** More precise than the earlier selectivity framing.

### 🔑 COVERING INDEXES — the `SELECT` list changes everything
All four plans say **COVERING**, because the queries only ask for `scheme_code`, `date`, or a
count — all of which live inside the index. **The table is never opened.**

Had `nav` (the value column) been selected, query 4 would have required a lookup back into the
table for every row and would have been dramatically slower.

*→ Applies directly in PostgreSQL: same index, same filter, wildly different performance
depending on which columns are selected. This is what index-only scans are.*

⚠️ The `detail` column truncates with "…" in DB Browser. **Widen it** to see *which* index was
chosen — for the `scheme_code` queries either `nav` index could theoretically serve, and knowing
which the planner picked is the point of running this.

### 🔬 PARSING PATHOLOGY CATALOGUE — one fund, nine codes (17 Aug 2026)

Query: `WHERE scheme_name LIKE 'Nippon India Growth%' OR LIKE '%Growth Mid Cap%' OR LIKE 'Reliance Growth%'`
Result: **9 codes.** (Prediction was 15–20 — over-estimated.)

| # | Code | Full scheme name |
|---|---|---|
| 1 | 118666 | `NIPPON INDIA GROWTH MID CAP FUND - DIRECT Plan - IDCW Option` |
| 2 | 118665 | `Nippon India Growth Mid Cap Fund - Direct Plan Growth Plan - Bonus Option` |
| 3 | 118668 | `Nippon India Growth Mid Cap Fund - Direct Plan Growth Plan - Growth Option` |
| 4 | 100375 | `NIPPON INDIA GROWTH MID CAP FUND - IDCW Option` |
| 5 | 106260 | `NIPPON INDIA GROWTH MID CAP FUND - INSTITUTIONAL Plan - IDCW Option` |
| 6 | 100376 | `Nippon India Growth Mid Cap Fund-Growth Plan-Bonus Option` |
| 7 | **100377** | `Nippon India Growth Mid Cap Fund-Growth Plan-Growth Option` |
| 8 | 106258 | `Reliance Growth Fund Institutional Plan Growth Plan Growth Option` |
| 9 | 106259 | `Reliance Growth Fund Institutional Plan Growth Plan Bonus Option` |

### Every defect visible in these nine rows

**1. Splitting on `" - "` yields: 3, 3, 3, 2, 3, 1, 1, 1, 1 pieces.**
Not constant across nine rows of the *same fund*.

**2. Three different separators**
- Rows 1–5: `" - "` (spaces around hyphen)
- Rows 6–7: `"-"` (no spaces)
- Rows 8–9: **no separator at all** — pure whitespace. Nothing to split on

**3. Inconsistent casing** — `NIPPON INDIA GROWTH MID CAP FUND` vs `Nippon India Growth Mid Cap
Fund`, same fund, same table. Exact-match logic breaks; `GROUP BY scheme_name` splits one fund
into two groups

**4. Missing levels** — row 4 goes fund → option with no plan at all

**5. 🔴 "Regular" never appears.** Only `Direct`, `Institutional`, or nothing.
**Regular = absence.** Detected by exclusion, never by keyword

**6. 🔴 Two plan layers stacked** — `Direct Plan Growth Plan`: modern plan (Direct) + legacy
plan (Growth). "Plan" appears twice meaning different things

**7. Repeated tokens at different levels** — `Growth Plan-Growth Option`. Position disambiguates;
keywords cannot

**8. Undocumented values** — `Bonus Option` (third option type), `Institutional Plan` (fourth
plan class, discontinued ~2012, fits no level of the clean model)

**9. Name is not stable over time.** The February disclosure says "Nippon India Growth Fund";
the archive says "Nippon India Growth **Mid Cap** Fund". **A `LIKE '%Nippon India Growth Fund%'`
search would have missed this scheme entirely.**
*→ The code was stable. The name was not. This is the concrete justification for D20.*

### 🔑 INFERENCE — the name encodes WHEN a scheme died
Rows 8–9 still say **"Reliance"**, having survived the 2019 Nippon acquisition un-renamed, while
everything else became "Nippon India".

Those plans were almost certainly **discontinued before the acquisition**. Dead schemes don't get
renamed — nobody updates a name no one will see.

**So live schemes carry the current name; dead ones are frozen at whatever they were called when
they stopped.** The name is a rough timestamp of death.

### 🔑 100377 confirmed as the Regular / legacy plan
Row 7: `Growth Plan-Growth Option` — **no Direct, no Institutional** → Regular by absence.
Confirms the 5,010-row inference made before any name was read.

**The Feb disclosure keys whole-scheme AUM (₹24,493.62 cr) to this single legacy Regular code.**
Granularity trap now confirmed twice independently.

### Code allocation is blocky — but NOT contiguous
`100375/376/377`, `106258/259/260`, `118665/666/668` — codes issued in batches as plans launched.

⚠️ **118667 does not exist at all** — verified, returns 0 rows from `schemes`. Not a scheme
missing NAV data; the code was never assigned or was purged. Given 118665/666/668 are the three
Direct-plan variants, 118667 was likely reserved for a fourth (probably an IDCW reinvestment)
that was registered and never launched.

🔑 **Rule: AMFI codes are NOT densely allocated.** Gaps exist inside otherwise contiguous blocks.
**Never infer that a code range is complete, and never generate a code by arithmetic on a
neighbouring one.** If you need to know a code exists, look it up.

### Note on redundant indexes
`securities.isin` is declared `TEXT UNIQUE`, and SQLite backs a UNIQUE constraint with an
implicit index (`sqlite_autoindex_securities_1`). `idx_securities_isin` was created anyway
**with no warning** — SQLite permits redundant indexes silently. Harmless at this size, but on
a write-heavy table it means maintaining two structures for one purpose.

### ✅ NO DUPLICATE `(scheme_code, date)` PAIRS — verified 17 Aug 2026
`GROUP BY scheme_code, date HAVING COUNT(*) > 1` → **0 rows** (9,421 ms).

**`(scheme_code, date)` is a genuine natural composite primary key** across all 36,765,864 rows.
No synthetic ID needed. See D24 — this determines both the Postgres schema and the load strategy.

### Scheme code counts (measured 17 Aug 2026)
| Query | Result | Time |
|---|---|---|
| `COUNT(DISTINCT scheme_code)` from `schemes` | **38,107** | 45 ms |
| `COUNT(DISTINCT scheme_code)` from `nav` | **37,501** | 8,978 ms |
| Net difference | **606** | |

⚠️ **Counts differing does NOT prove containment.** A net difference of 606 is consistent with
"606 schemes have no NAV rows" *and* with "700 schemes have no NAV rows plus 94 orphaned NAV
codes pointing at schemes that don't exist." Same net number, very different meaning.

**The foreign key on `nav.scheme_code` is declared but SQLite does not enforce foreign keys
unless explicitly enabled**, so orphaned NAV rows are genuinely possible.
*→ Run the set comparison **both ways** (`NOT IN` or `LEFT JOIN ... WHERE NULL`). Each direction
is a separate defect class for the reconciliation layer.*

**Timing contrast is instructive:** 45 ms vs 8,978 ms for the same query shape. `schemes` is
small and has a PRIMARY KEY index; `nav` has 36.7M rows and no index at all. That gap is the
argument for indexing, visible before a single index has been created.

### ⚠️ SCALE CORRECTION — 38,107 codes, not "~2,500 schemes"
Earlier notes assumed ~2,500 schemes. **That is the count of LIVE schemes AMFI publishes today.**
This archive holds 20 years including everything since discontinued.

**Most likely explanation: Fixed Maturity Plans (FMPs).** Closed-ended debt schemes with a fixed
maturity date, launched by AMCs in batches of dozens through the 2010s. Each gets a code, runs
~3 years, matures, disappears. They accumulate into thousands of dead codes.

**Consequence for the scheme dimension:** most of what the parser encounters will be dead FMPs
with names like `XYZ Fixed Maturity Plan Series 24 Plan B - Regular - Growth`, **not** the equity
funds this project is about.

*→ **Resolved by D22:** load all 38,107 codes, but parse names only for the schemes the analysis
touches (~30–40 codes). Loading is cheap and requires no name understanding; parsing is the
expensive part and is scoped narrowly. Document the filter as a scope decision, not an oversight.*

### ✅ RESOLVED — referential integrity checked BOTH ways (17 Aug 2026)

| Direction | Query | Result | Time |
|---|---|---|---|
| Orphaned NAV rows | `nav LEFT JOIN schemes WHERE s.scheme_code IS NULL` | **0 rows** | 13,956 ms |
| Schemes with no NAV | `schemes LEFT JOIN nav WHERE n.scheme_code IS NULL` | **606 rows** | **453,207 ms** |

**Zero orphaned NAV rows** — every `scheme_code` in `nav` has a matching row in `schemes`,
despite SQLite not enforcing the declared foreign key. The maintainer's import was disciplined.

**Exactly 606 schemes with no NAV rows**, matching the net count difference precisely.
**Containment is now empirically confirmed**, not assumed: 37,501 ⊂ 38,107.

### ⏱️ THE 7.5-MINUTE LESSON
The second query took **453,207 ms — over seven and a half minutes** — run before any indexes
existed. A nested loop join across 36.7M unindexed rows costs exactly that: every row of `nav`
scanned once per lookup, with no index to jump into.

**After indexing the same query took 2,545 ms — a 178× improvement.**
Building all four indexes took 55 seconds total. **This one query paid for them 8× over.**

*→ This is D12 experienced rather than read.*

### Open: what ARE the 606?
Sample their names. Likely NFOs registered but never launched, or schemes withdrawn before
their first NAV. Classifying them is better than merely counting them.

### 🔑 INFERENCE — 100377 is almost certainly a REGULAR plan code
`COUNT(*) WHERE scheme_code = 100377` → **5,010 rows.**

2006-04-01 to 2026-08-16 ≈ 20.4 years × ~250 trading days ≈ **~5,100 expected rows** for full
coverage. 5,010 is near-complete history from the start of the dataset.

**Direct plans only began in January 2013**, so a Direct code cannot exceed ~3,400 rows.
This code has NAV back to 2006 → **it is a legacy Regular plan.**

**This confirms the join granularity trap.** The Feb disclosure supplies one code per scheme
alongside **whole-scheme AUM** (₹24,493.62 cr) — and the code supplied is the old Regular plan.
A naive join would attribute the entire scheme's AUM to a single share class.

*→ Verify by reading the actual name, but note the row count alone revealed the structure.*

### 🔴 Finding 3 — no AUM anywhere
Confirms the design: AUM must come from the stress test files (Part 10). There is no AUM in the
NAV archive at all, so the two sources are genuinely complementary rather than overlapping.

### Structural notes
- **`schemes` is one row per `scheme_code`**, holding the free-text `scheme_name`. This is the
  table the scheme-dimension parsing work operates on — *not* `nav`
- **`securities.isin` is UNIQUE**, and multiple ISINs map to one `scheme_code`. AMFI publishes
  separate ISINs for payout and reinvestment variants, so `type` (INTEGER) most likely encodes
  that distinction. ⚠️ Confirm what the integer values mean — it is undocumented in the schema
- **Foreign keys are declared** on both `nav` and `securities` pointing at `schemes`. Worth
  checking whether they are actually enforced — SQLite requires foreign key enforcement to be
  switched on explicitly, and orphaned `scheme_code` values are a defect class in their own right

### Index strategy (created manually after decompression)
| Index | Purpose |
|---|---|
| `nav(date, scheme_code)` | Date-range queries — the event analysis |
| `nav(scheme_code)` | Single-scheme history. **Needed separately** — the composite is sorted by date first, so it cannot serve a scheme_code-only lookup (leftmost prefix rule) |
| `securities(scheme_code)` | Join performance |
| `securities(isin)` | ISIN lookups |

**Verify with `EXPLAIN QUERY PLAN`.** `SCAN nav` means the index is not being used;
`SEARCH nav USING INDEX ...` means it is. The Postgres equivalent is `EXPLAIN ANALYZE`.
