# NOTES.md — Concepts, Vocabulary & Domain Knowledge

**Project:** Small-cap stress testing & AMC inflow restrictions (Feb–Mar 2024)
**Purpose:** Revision file. Everything here should be explainable out loud without notes.
**Last updated:** 24 August 2026

---

## PART 0 — WHAT THIS PROJECT IS ACTUALLY ASKING

*Written 22 Aug 2026. Everything else in this file exists to serve what's on this page.*

### The objective, in one paragraph
In February 2024 AMFI told fund houses to moderate inflows into small and mid-cap funds. Some
restricted, some didn't. A month later small-caps fell ~13%. **This project asks whether those
restriction decisions actually mattered** — whether they changed anything at all, whether the
funds that restricted came through the correction better, and whether pre-event portfolio
characteristics explain the differences between them.

### 🔑 THE MECHANISM — why would a restriction matter at all?

**The analogy.** You run a shop that buys second-hand cars and sells shares in the collection.
Cars are absurdly expensive right now — one worth ₹5 lakh two years ago sells for ₹12 lakh. You
think it's madness. **But money keeps arriving**, ₹100 crore a month, from people who saw how
well the collection did.

That money is a problem, not a gift. Two options, both bad:
1. **Buy cars at ₹12 lakh** you think are worth ₹5 lakh. When prices correct, those crash hardest —
   and the loss hits *everyone*, because everyone owns a slice of the same collection. Five-year
   investors get dragged down by purchases they never asked for
2. **Leave it in the safe.** Nothing lost, nothing earned — and that idle cash is part of the
   collection everyone owns, so it drags down everybody's returns while prices keep climbing

**No good third option.**

**The escape:** put a sign on the door — *not accepting new investors*. No new money means no
forced choice. You just manage what you already have.

**That is exactly what those AMCs did in Feb 2024.** They did not stop people *leaving* —
redemptions stayed open. They stopped people **coming in**.

### Why they did it
Small-cap shares had gotten expensive the same way. Nippon's small-cap fund showed a trailing
P/E of **41.91** in the Feb 2024 file — investors paying ₹41.91 for every ₹1 of annual profit.
Historically that figure sits nearer 16–20. Meanwhile retail money poured in *because* prices
had been rising. The managers were staring at the trap.

### 🔑 THE CENTRAL HYPOTHESIS
**Funds that shut the door should have come through the correction in better shape than funds
that stayed open** — because the open-door funds spent February and early March buying expensive
shares with money they didn't want, right before prices fell. The closed-door funds didn't.

**Everything else in the project exists to test this.**

### The four questions, in dependency order
**Q1 — Did the restrictions actually reduce inflows?**
🔴 **This is the first-stage test and it gates everything else.** If restricted funds took in as
much money as unrestricted ones, the treatment did nothing and Q2–Q4 are meaningless.
**This is what the flow decomposition is for.** Run it first.

**Q2 — Did restricted funds fall less in March?** NAV drawdown, treated vs control.

**Q3 — Did they recover differently?** March through ~September 2024. Open-door funds bought at
the top, so their recovery may look different.

**Q4 — What explains differences *within* each group?** A fund already holding lots of cash
didn't need to buy anything either — it had its own escape route. A fund needing 29 days to
liquidate half its portfolio was in more danger than one needing 6.

### The variables and why each exists
| Role | Variable | Source | Why it's here |
|---|---|---|---|
| **Treatment** | Restricted / not, and type | AMC addenda | The thing being tested |
| **First stage** | Monthly net flow | Monthly AUM + NAV return | Q1 — did the sign on the door work? |
| **Outcome** | Peak-to-trough drawdown Feb–Mar | NAV | Q2 |
| **Outcome** | Recovery speed | NAV | Q3 |
| **Explanatory** | Cash % | Feb 2024 stress test | Own escape route — didn't need to buy |
| **Explanatory** | Days to liquidate 25/50% | Feb 2024 stress test | Trapped-ness |
| **Explanatory** | Top-10 investor % | Feb 2024 stress test | Stampede risk |
| **Explanatory** | Trailing P/E | Feb 2024 stress test | How overpriced going in |
| **Explanatory** | Small-cap %, AUM | Feb 2024 stress test | Exposure and size |

### 📌 PRE-REGISTERED EXPECTATIONS (written 22 Aug 2026, before running anything)
*Recorded so results cannot be rationalised after the fact.*

1. Restricted funds took **materially less** money in March
2. Drawdown differences between treated and control will be **SMALL** — all small-cap funds hold
   similar stocks and fell together
3. **Pre-event cash will explain more variation than the restriction itself**
4. Dispersion between fund houses will be **larger** than the ₹94 cr category headline suggests

⚠️ **If the drawdown difference turns out large, be suspicious** — it likely means the control
group is contaminated.

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

⚠️ **Most dates below are news-sourced.** Exception: **27 Feb 2024 is now primary-sourced** —
Nippon's board-approved policy document (both v1.0 and v2.0) opens by citing a SEBI email of that
date. See Part 14.

### Timeline
| Date | Event |
|---|---|
| Feb 2024 | Nifty Smallcap 250 up ~71% over prior 52 weeks; Nifty Midcap 100 up ~64% vs Nifty ~28% |
| **27 Feb 2024** | SEBI email directs AMFI to tell all AMC Trustees to **frame a policy** to protect small/midcap investors. The mandate is procedural — *have a policy* — not an instruction to restrict. "Moderating inflows" appears in Nippon's own policy as one example measure among others, not as the mandate's text. Letter not publicly disclosed; SEBI date confirmed from Nippon's policy document (Part 14) |
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

### AMC responses
**Nippon — fully primary-sourced, see Part 14.** Fresh lumpsum and switch-ins suspended from
07-Jul-2023; SIP/STP cap cut ₹5 lakh → ₹50,000 per day per PAN and exit load extended 1 month →
1 year, both effective 22-Mar-2024.

**Still news-sourced, to be verified from addenda:** Tata, SBI, Kotak, ICICI Prudential,
Franklin Templeton (lumpsum capped ₹2 lakh/month, SIP ₹50,000/month), Motilal Oswal
(exit load change).

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

### ✅ SOURCE VERIFICATION QUERIES — run before declaring constraints (22 Aug 2026)
Each constraint in the Postgres schema was checked against the SQLite source first.

| Check | Query | Result | Time |
|---|---|---|---|
| Null NAV values | `WHERE nav IS NULL` | **0** | 4,517 ms |
| Zero/negative NAV | `WHERE nav <= 0` | **0** | 2,706 ms |
| Null ISINs | `WHERE isin IS NULL` | **0** | 14 ms |
| Blank ISINs | `WHERE isin = '' OR trim(isin) = ''` | **0** | 47 ms |

⚠️ **Null and blank are different things.** A blank string passes an `IS NULL` check and passes a
`UNIQUE` constraint, but is not a valid identifier. Always check both.

**Principle: a constraint is a stated belief the database will check for you.** Declare what you
believe to be true and let it fail loudly if you're wrong — rather than hoping and finding out
during analysis.

### 🖥️ psql vs PowerShell — two different prompts
Repeated source of confusion, worth fixing once.

| Prompt | What it is | Runs |
|---|---|---|
| `PS C:\...>` | Windows PowerShell | `psql`, `git`, `python` |
| `amfi=#` | inside psql | SQL and backslash commands |
| `amfi-#` | **psql mid-statement** | waiting for a `;` — everything typed is being swallowed |

- **From PowerShell:** `psql -U postgres -d amfi -f path/to/file.sql` — runs the file and exits
- **From inside psql:** `\i path/to/file.sql` — runs the file in the current session
- **Never** type `psql ...` while already inside psql
- `-c "..."` executes one statement and exits — it never enters the interactive prompt
- `\copy` is a psql backslash command, so it only exists at the `amfi=#` prompt

*The `U` marker on a VS Code tab is git's **Untracked** status, not an unsaved-file marker.
Unsaved shows as a filled dot.*

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
- [x] 🔴 **What does AMFI code 100377 resolve to?** → `Nippon India Growth Mid Cap Fund-Growth
      Plan-Growth Option` — a single legacy **Regular** plan, while the disclosure's AUM covers the
      whole scheme. **Granularity trap confirmed** (Part 11)
- [ ] 🔴 **Run the March 2024 flow decomposition on 100377 and 113177.** Did Nippon take
      inflows during the crash while the category saw net outflows? (Finding 2, Part 10)
- [ ] Confirm the volume-collapse explanation for rising liquidation days — is NSE/BSE
      March 2024 volume data available to verify it directly?
- [x] **Why did Small Cap liquidation days stay flat while AUM grew 23%?** → Answered by the
      March file: the metric tracks market volumes, not just fund size
- [x] Do the other AMCs archive back to Feb 2024? → **YES, all 24 reachable.** Sweep complete,
      see Part 15. Archive structures vary wildly; URL conventions are never predictable
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
- [ ] 🔴 **How many of the 24 fund houses have PRIOR restriction history** (pre-2024)?
      Determines whether the treatment variable needs restructuring — see D29
- [ ] Verify the ₹94 cr March 2024 category net outflow against AMFI's monthly report.
      Currently news-sourced, and Finding in Part 13 leans on it
- [x] Does Nippon's "Policy on Mid Cap and Small Cap category" page state their position on the
      Feb 2024 mandate directly? → **YES.** Both versions cite a SEBI email of 27 Feb 2024
      directing AMFI to have AMCs frame a policy. Confirms the date from a primary source, and
      shows the mandate was **procedural, not an instruction to restrict**. See Part 14
- [x] **Exact effective dates for each AMC restriction** → **Nippon done** (07-Jul-2023 and
      22-Mar-2024, Part 14). Remaining 23 open
- [ ] 🔴 **Do other AMCs' March 2024 addenda also take effect AFTER their fund's trough?**
      Nippon's did, by nine days. If this generalises, Q2 is not answerable as designed — see D31
- [ ] 🔴 **How many of the 24 were already restricted on 1 Feb 2024?** Distinct from D29's
      prior-history question: not "have they ever restricted" but "was a restriction in force
      during the correction." Nippon: yes, since Jul 2023
- [ ] Does every AMC publish a "Policy to protect the interest of investors of small/mid-cap
      schemes"? Cheap status source across all 24 if so — see D30
- [ ] Do other AMCs run a stale archive page alongside a current one, as Nippon does? (Part 14)


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

---

## PART 12 — THE POSTGRES BUILD (24 Aug 2026)

### Schema complete — 7 tables across 8 numbered files
| File | Creates |
|---|---|
| `001_schemas.sql` | namespaces `staging`, `core` |
| `002_schemes.sql` | `core.schemes` |
| `003_securities.sql` | `core.securities` |
| `004_nav.sql` | `core.nav` |
| `005_amc.sql` | `core.amc` |
| `006_scheme_lineage.sql` | `core.scheme_lineage` |
| `007_stress_test.sql` | `core.stress_test` |
| `008_indexes.sql` | 2 secondary indexes — **run after load** |

Seeds in `sql/load/`: `001_seed_amc.sql` (24 rows), `002_load_core.sql` (bulk `\copy`),
`003_seed_scheme_lineage.sql` (1 row).

### Load results — all counts exact
| Table | Rows |
|---|---|
| `core.schemes` | **38,107** |
| `core.securities` | **34,937** |
| `core.nav` (Jan 2022 → present slice) | **8,931,779** |

⚠️ **The slice is 8.93M rows, not the ~6M estimated.** Scheme counts have grown over time, so
recent years are denser than the 20-year average implies.

**What the load silently proved:** ~27M constraint evaluations passed — every FK checked against
`core.schemes`, every `nav_value` tested against `CHECK (> 0)`, every `(scheme_code, nav_date)`
pair tested for uniqueness. **In SQLite these properties were established by querying. In Postgres
they are enforced at the door and will be enforced on every future load.**

### 🔑 69% of the archive is dead schemes
`COUNT(DISTINCT scheme_code)` in the slice → **11,651**. Against 38,107 total, that leaves
**26,456 schemes with no NAV since January 2022** — confirmed exactly by the LEFT JOIN count.

Direct confirmation of the FMP hypothesis. Also validates the narrow-parsing decision: a universal
parser would have processed 26,456 funds that have not existed in years.

### Postgres vs SQLite benchmarks
| Query | SQLite (indexed, 36.7M rows) | Postgres (indexed, 8.9M rows) |
|---|---|---|
| `COUNT(*) WHERE scheme_code = 100377` | 24 ms | 14.4 ms cold / **0.32 ms warm** |
| `ORDER BY nav_date DESC LIMIT 10` | 13 ms | **0.07 ms** |
| `COUNT(DISTINCT scheme_code)` | 1,509 ms | **9,418 ms** ← Postgres much slower |
| `schemes LEFT JOIN nav` | 2,545 ms | **379 ms** |

🔑 **`COUNT(DISTINCT)` is a known Postgres weakness** — it sorts or hashes every value rather than
exploiting index ordering the way SQLite does. Six times slower on a quarter of the data.

🔑 **Cold vs warm cache:** the same query showed 14.4 ms on first run and 0.32 ms under
`EXPLAIN ANALYZE`. **The first run of anything measures the SSD, not the query.**

### `EXPLAIN ANALYZE` confirmed the index design
- `WHERE scheme_code = 100377` → **`Index Only Scan using pk_nav`**, `Heap Fetches: 0`.
  The composite PK's leading column answered it; a separate `scheme_code` index would be redundant
- `ORDER BY nav_date DESC LIMIT 10` → **`Index Only Scan Backward using idx_nav_date_scheme`**.
  The PK cannot serve this — leftmost prefix rule verified by the planner

**Postgres terminology map:** `Index Only Scan` = SQLite's `COVERING INDEX`. `Seq Scan` = no index.
`EXPLAIN ANALYZE` executes the query and reports real timings, unlike `EXPLAIN QUERY PLAN`.

---

## PART 13 — FIRST ANALYSIS: NIPPON, MARCH 2024 (24 Aug 2026)

### 🔑 THE MEASUREMENT LESSON — the most important thing learned so far

**Month-end returns and peak-to-trough drawdown are different measures and give opposite answers.**

| | Month-end return (29 Feb → 31 Mar) | Peak-to-trough drawdown |
|---|---|---|
| Small Cap Fund (113177) | **−0.92%** | **−8.45%** |
| Growth Fund (100377) | **+0.70%** | **−6.74%** |

Nine-fold difference. Same funds, same period.

**Why:** the segment crashed in early-to-mid March and rebounded hard before month-end. Comparing
two endpoints sees only the net of a violent round trip. *Analogy: checking your phone only on the
first and last day of the month — you would have no idea anything happened.*

**Peak** = highest point. **Trough** = lowest point after it. **Drawdown** = the fall between them.
Both measures are correct; the first says *if you never looked, you did fine*, the second says
*at the worst moment this lost X%*.

*→ Part 0's outcome variable is peak-to-trough drawdown. That choice is now empirically justified,
not stylistic. Month-end returns would have shown the correction barely touched these funds.*

### Peak and trough dates — and two problems they reveal
| Scheme | Peak | Trough | Drawdown |
|---|---|---|---|
| Small Cap (113177) | 7 Feb 2024, 145.0926 | 13 Mar 2024, 132.8328 | −8.45% |
| Growth / mid cap (100377) | 8 Feb 2024, 3319.7172 | 20 Mar 2024, 3096.0721 | −6.74% |

🔴 **Problem 1 — the peaks precede the intervention.** Peaks are 7–8 Feb; the AMFI letters are
27–28 Feb. **These funds had been falling for three weeks before the intervention landed.**
So the restrictions did not cause the decline, and were not a response to a fall that had visibly
started — they landed mid-slide. The question is therefore not *"did the restriction prevent a
fall"* but *"did it change what happened after the fall was already underway."* State this plainly.

🔴 **Problem 2 — troughs differ by a week.** 13 Mar vs 20 Mar. There is **no common bottom date**.
Each scheme needs its own trough found independently — a `PARTITION BY scheme_code` job when
scaling to 24 fund houses, not a fixed date.

Small cap fell more than mid cap (8.45% vs 6.74%), consistent with small caps being the frothier
segment and the one the regulator named.

### ✅ Q1 ANSWERED — the flow decomposition
Formula: **Net flow ≈ AUM_end − [AUM_start × (1 + NAV return)]**

| Scheme | Feb AUM | Mar AUM | NAV return | Expected AUM | Implied flow |
|---|---|---|---|---|---|
| Growth Fund | ₹24,493.62 cr | ₹24,796.00 cr | +0.70% | ₹24,665.7 cr | **+₹130 cr INFLOW** |
| Small Cap Fund | ₹46,029.84 cr | ₹45,248.33 cr | −0.92% | ₹45,605.0 cr | **−₹357 cr OUTFLOW** |

**They moved in opposite directions.** The restricted small-cap fund bled; the mid-cap fund took
money in.

### 🔑 FINDING — the category headline masks large dispersion
The small-cap **category** recorded **₹94 cr net outflow** in March 2024.
Nippon's single scheme lost **₹357 cr** — nearly **four times the entire category's net figure**.

**If one AMC accounts for 4× the category's net outflow, the rest of the category must have been
taking money in.**

*→ This is pre-registered expectation #4 (Part 0), and it is the "why did one company behave
differently" question the project was built around.*

⚠️ **Do not overclaim.** The ₹94 cr figure is news-sourced and needs verifying against AMFI's
monthly report. And the AUM is whole-scheme while the NAV is one plan.

### ⚠️ Known approximation — the granularity trap in the analysis
AUM is whole-scheme across all plans and options. NAV is for **one plan** (100377 is legacy
Regular Growth). Direct plans return slightly more because expenses are lower, so a Regular return
understates the whole-scheme return marginally. Over one month the error is a few basis points.
**Acceptable, but it belongs in the write-up rather than being quietly ignored.**

### 🔴 TREATMENT DEFINITION PROBLEM — Nippon has restricted this fund for six years
From Nippon's addenda archive:

| Date | Action |
|---|---|
| 2018 | Limit the subscription in Reliance Small Cap Fund |
| 14-10-2019 | Fresh subscription limit via SIP/STP raised ₹1 lakh → ₹5 lakh |
| 16-03-2020 | Acceptance of subscription of units |
| 31-03-2020 | **Withdrawal** of subscription limit |
| 04-02-2021 | Revision in exit load structure, w.e.f. 5 Feb 2021 |
| **07-07-2023** | **Fresh lumpsum/switch-ins suspended; SIP/STP capped ₹5 lakh/day/PAN** (primary-sourced, Part 14) |
| **22-03-2024** | **SIP/STP cap cut to ₹50,000/day/PAN; exit load 1 month → 1 year** (primary-sourced, Part 14) |

**March 2024 was not a first intervention. It is the latest in a six-year pattern of tightening
and loosening.**

*→ "Restricted in 2024" does not cleanly separate Nippon from an AMC restricting for the first
time. For Nippon the behaviour is continuation of policy, not response to the event. An AMC with a
documented history of capping inflows is a different animal from one that had never done so.*
**This must be handled in the treatment definition — see D29.**

### Source URLs
- 🔴 **Nippon addenda — CURRENT page:**
  `https://mf.nipponindiaim.com/investor-service/quick-links/notice-addendum`
- ⚠️ Nippon addenda — **STALE** archive page, newest entry 31-10-2022. Do not use:
  `https://mf.nipponindiaim.com/investor-service/downloads/notice-addendum`
  (An earlier note claimed the 2024 entries here needed a JavaScript year filter. **That was
  wrong.** They are on the Quick Links page, which is a different URL. See Part 14)
- Addendum PDFs live under `https://mf.nipponindiaim.com/InvestorServices/Addenda/`
  — **filenames have no pattern and cannot be constructed. Harvest the href.**
- 🔑 **Nippon's stated mid/small cap policy:**
  `https://mf.nipponindiaim.com/investor-service/disclosures/policy-on-mid-cap-and-small-cap-category`

---

## PART 14 — NIPPON ADDENDA, PRIMARY SOURCED (27 August 2026)

Everything in this Part comes from the documents themselves, not from news reporting.

### The two-page trap

Nippon has **two** pages both titled "Notice/Addendum":

| Path | State |
|---|---|
| `/investor-service/downloads/notice-addendum` | **Stale archive.** Newest entry 31-10-2022 |
| `/investor-service/quick-links/notice-addendum` | **Current.** Runs to the present |

Same name, different section of the site menu. Landing on the Downloads page makes it look as
though the fund house stopped publishing addenda in 2022.

**Before recording any AMC as having no recent addenda, look for a second page.** This is now the
first check in the sweep protocol (D30).

### Filenames are not constructible

Four files from the same `/InvestorServices/Addenda/` folder:

- `94-Exit-load-of-Small-cap-and-further-limit-subscription.pdf`
- `33-Small-cap-fund-restriction.pdf`
- `Limit-the-subscription-in-Nippon-India-Small-Cap-Fund.pdf`
- `Notice-No-82-W12-x-H15.pdf`

No pattern. The `W12 x H15` in older filenames appears to be newspaper advertisement dimensions
— a printing artifact, not an identifier.

**Harvest the href; never build the URL.** Same lesson as the stress test files, now the second
occurrence. This is why the source URL column in the restriction table is mandatory rather than a
convenience: there is no rule that would let it be regenerated later.

### Nippon India Small Cap Fund — restriction timeline

| Effective | Fresh lumpsum / additional / switch-in | Fresh SIP/STP cap | Exit load |
|---|---|---|---|
| before 07-Jul-2023 | open | none | 1% within 1 month |
| **07-Jul-2023** | **suspended till further notice** | **₹5 lakh/day/PAN** | 1% within 1 month |
| **22-Mar-2024** | still suspended | **₹50,000/day/PAN** | **1% within 1 year** |

**Sources:**
- Notice cum Addendum no. 20, dated 06-Jul-2023, effective 07-Jul-2023
  — `Limit-the-subscription-in-Nippon-India-Small-Cap-Fund.pdf`
- Corrigendum to no. 20, same date
  — `Corrigendum-Limit-the-subscription-in-Nippon-India-Small-Cap-Fund.pdf`
- Notice cum Addendum no. 94, dated 19-Mar-2024, effective 22-Mar-2024
  — `94-Exit-load-of-Small-cap-and-further-limit-subscription.pdf`

**Exact wording of the July 2023 suspension:** fresh/additional subscriptions and switch-ins
"will not be allowed/accepted at any point of time till further notice."

**Carve-outs, identical in both addenda:**
- SIP/STP registered **before** the effective date continue unaffected
- Dividend Reinvestment Option unitholders unaffected
- AMC and designated-employee mandatory contributions exempt

**Stated rationale, near-identical wording in both:** to facilitate gradual deployment of corpus
in order to align with the nature of small-cap investing, warranted by the sharp rally in the
small-cap space and increased participation through high-ticket investments.

### 🔴 Finding 1 — the March restriction post-dates the trough

Addendum 94 was published 19-Mar-2024 and takes effect **22-Mar-2024**.
The Small Cap Fund trough (Part 13) is **13-Mar-2024**.

**The March 2024 restriction took effect nine days after the fund had already bottomed.** It
cannot have caused or moderated the drawdown, because it did not exist yet.

For Nippon, the restriction operating throughout the correction is the **July 2023** one.

This is a harder problem than D28's observation that peaks preceded the intervention. That was
awkward timing. This is the cause arriving after the effect. If the same pattern holds at other
AMCs, **Q2 (drawdown by treatment group) may not be answerable as written**, and the live
questions become Q1 (flows) and Q3 (recovery). See D31.

### 🔴 Finding 2 — Nippon has no before-and-after on the main mechanism

Fresh lumpsum and switch-ins were suspended **continuously** from 07-Jul-2023 through the
pre-period, the correction and the recovery. The "no new money means no forced choice" mechanism
described in Part 0 was in force the entire time.

What actually changed in March 2024: the SIP cap fell 10×, and the exit load extended from one
month to one year. Both are real changes, but both are narrower than "shut the door."

**D29 option 1 (binary treated/control) is therefore eliminated for Nippon** — not as a
hypothesis but as a documented fact.

### Finding 3 — the restriction is narrower than "closed"

Existing SIPs and STPs kept running throughout. Only **new** registrations were capped, and
capped rather than blocked. Dividend reinvestment continued.

So the fund kept receiving money from every SIP registered before July 2023 — which is most of
them. This is the mechanism behind the Part 13 flow result, and the Part 0 description of the
treatment should be read with this narrowing in mind.

### Corrigenda exist and can change meaning

The 06-Jul-2023 corrigendum reissued **only** the fresh-registration paragraph, on the same day
as the original addendum.

The change: the original read "SIP **without initial investment** or STP...", the corrigendum
dropped that condition. The amount (₹5 lakh/day/PAN) was unchanged.

Reading only the original would have misstated who the restriction applied to.
**Check for a corrigendum on every addendum harvested.**

### Drafting convention to watch

Both addenda use the phrase "shall **continue** with a limit of Rs X" — July says ₹5 lakh,
March says ₹50,000.

The word describes *the cap remaining in place*, not *the level being unchanged*. A phrase that
reads like continuity may in fact be announcing a change.

**Compare the numbers, not the verbs.** The same house style will appear at other AMCs.

### One addendum, two restriction types

Addendum 94 contains an exit load revision **and** a subscription limit, sharing a single
effective date. The restriction table must be able to hold both without forcing a choice between
them — see D30.

### Checked and cleared: the 22-Feb-2024 addendum

Addendum 84, "Suspension of subscription in certain schemes of Nippon India Mutual Fund," dated
22-Feb-2024 — five days **before** the SEBI email, which would have been significant.

**It is overseas funds only:** Nippon India US Equity Opportunities Fund, Nippon India Japan
Equity Fund, Nippon India Taiwan Equity Fund, Nippon India ETF Hang Seng BeES. The cause is
overseas investment limit headroom, traceable back to a SEBI email of 28-Jan-2022 and an AMFI
communication of 30-Jan-2022.

**Nothing to do with small caps. The event date is unaffected.**

### The policy documents — a separate document class

Nippon publishes a "Policy to protect the interest of investors of small-cap & mid-cap schemes":

- **v1.0**, dated 16-Mar-2024
- **v2.0**, dated October 2024
- at `/investor-service/disclosures/policy-on-mid-cap-and-small-cap-category`

Both open by citing the SEBI email of 27-Feb-2024 directing AMFI to have all AMC Trustees frame
such a policy. **Every AMC was directed to do this, so every AMC probably has one** — potentially
a cheap status source across all 24.

**But it is not a substitute for the addenda:**

- **No effective dates.** Section 5.2 says a restriction is "currently" in place. It is a status
  snapshot, not an event log. Treatment timing cannot be recovered from it
- **v1.0 is dated 16-Mar-2024** — a restriction imposed on, say, 20 March would not appear in it
- **Silence ≠ control.** An AMC that never restricted may simply have no 5.2 paragraph. Absent
  evidence is `unknown`, and the absence looks deceptively like a clean negative

**Policy documents give status. Addenda give dates and history.** Both are needed — see D30.

Note also: section 5.2 of both versions names **only the Small Cap Fund**. The mid-cap Growth
Fund carries no restriction anywhere in the document. Within Nippon, 113177's scheme is
restricted and 100377's is not — which is consistent with the Part 13 flow result, though with
n=2 that is a consistency check passing, not a finding.

### Compliance finding in Annexure A

The policy document reproduces the SEBI/AMFI-approved stress test disclosure template. Its first
two columns are **AMFI Scheme Code** and **As of (Portfolio date)**, with example rows dated
29-02-2024.

Part 10 records that Nippon's actual March, April, May and June 2024 files **dropped both
columns**, starting instead at Scheme Name.

So: the approved template mandates the join key, the February file supplied it, and every
subsequent file omitted it. That is a documented deviation from a regulator-approved format,
found by comparing the template against the delivered files — a considerably better interview
answer than "the format was inconsistent."

⚠️ **Column-lettering trap.** The template labels its data columns **(A)–(O)**, starting at
days-to-liquidate. Part 10 labels the spreadsheet columns **A–Q**, starting at Scheme Name.

**These are two different lettering schemes for the same file.** "Column C" means top-10 investor
concentration in the methodology note, and a days-to-liquidate figure in the actual spreadsheet.
The template's own footnote is internally inconsistent too — it calls Beta (I) where the table
says (J), and turnover (N) where the table says (O), suggesting it was carried over from an
earlier revision with fewer benchmark columns.

**Name columns semantically in all loader code. Never by letter.** A header comment saying
"column C" is unreadable to future-you.

---

## PART 15 — THE FULL 24-AMC ADDENDA SWEEP (29 August 2026)

Every fund house in the study universe checked against its own addenda archive, cross-checked
against third-party fund data and contemporaneous reporting. **This Part supersedes all
news-sourced restriction claims elsewhere in NOTES.**

### The headline result

| | Small-cap state, Feb 2024 | Acted in Feb–Mar 2024 window |
|---|---|---|
| **SBI** | lumpsum closed since 08-Sep-2020 | no |
| **Tata** | lumpsum closed since 01-Jul-2023 | no |
| **Nippon** | lumpsum closed since 07-Jul-2023 | **yes — eff. 22-Mar** |
| **Kotak** | open | **yes — eff. 04-Mar** |
| **ICICI Prudential** | open | **yes — eff. 14-Mar** |
| **Franklin Templeton** | open | **yes — eff. 18-Mar** |
| **Axis** | ₹1 cr/day cap — nominal | no |
| ABSL, Bandhan, BOI, Baroda BNP, Canara Robeco, DSP, Edelweiss, HDFC, HSBC, Invesco, ITI, Mahindra Manulife, PGIM, Sundaram, UTI, Union, quant | open | no |

**Three fund houses were already closed to lumpsum going into February 2024.
Four acted inside the window. Seventeen did nothing at all.**

### 🔴 Finding 1 — the intervention produced almost no new restrictions

Of 24 fund houses facing the same SEBI/AMFI communication on the same date, **four** changed
their small-cap subscription terms in the following month. Two of those four were already
restricted and merely tightened.

**Genuinely new restrictions: Kotak, ICICI Prudential, Franklin — three of 24.**

### 🔴 Finding 2 — the timing does not support a causal story

| AMC | Effective | vs 13-Mar-2024 trough | vs 27-Feb SEBI email |
|---|---|---|---|
| Kotak | 04-Mar-2024 | 9 days **before** | addendum dated **26-Feb — one day before the email** |
| ICICI Pru | 14-Mar-2024 | 1 day after (cut-off 3pm, 13-Mar) | after |
| Franklin | 18-Mar-2024 | 5 days after | after |
| Nippon | 22-Mar-2024 | 9 days after | after |

Kotak's board decided **before the SEBI email existed**. The other three took effect **on or
after the trough** — they cannot have caused or moderated a drawdown that had already ended.

This is D31 with four confirming cases rather than one. Q2 as originally framed is not
answerable from these dates.

### 🔴 Finding 3 — the restrictors moved 7 months to 3.5 years BEFORE the mandate

SBI (Sep 2020), Tata (Jul 2023) and Nippon (Jul 2023) all closed lumpsum well ahead of the
event, citing the small-cap rally and corpus deployment — not any regulatory instruction.
The regulator's intervention largely landed on fund houses that had already acted or would
not act at all.

### Finding 4 — fund size does NOT sort the groups (hypothesis tested and rejected)

Raised repeatedly during the sweep as the obvious confounder. It does not hold:

- **HDFC** (~₹25,000–28,000 cr, among the two largest small-cap schemes) — **stayed open**
- **quant** (~₹2,000 cr → ₹17,000 cr across 2023, the fastest growth in the industry) — **stayed open**
- **Canara Robeco** (~₹7,800 cr, +40% 1-yr return) — **stayed open**
- **ICICI Pru** (~₹7,000 cr) — **suspended lumpsum entirely**
- **Kotak** (~₹14,500 cr) — capped

Record as a checked-and-rejected confounder, not an open question.

### Finding 5 — restriction is not binary; it is a state with several dimensions

Lumpsum status and SIP cap move independently, and severity ranges enormously:

| | Lumpsum | Fresh SIP/STP cap |
|---|---|---|
| SBI | closed | ₹25,000/**month** |
| Tata | closed | **uncapped** |
| Nippon (from 22-Mar) | closed | ₹50,000/**day** |
| ICICI Pru (from 14-Mar) | suspended | ₹2,00,000/month |
| Kotak (from 04-Mar) | ₹2,00,000/month | ₹25,000/month |
| Franklin (from 18-Mar) | ₹2,00,000/month | ₹50,000/month |
| Axis | ₹1 crore/**day** | included in the same cap |

⚠️ **Unit trap: SBI and Kotak are per MONTH, Nippon and Axis per DAY.** ₹25,000/month vs
₹50,000/day is a ~60× difference annually, not 2×. **The table must store the unit**, or any
comparison silently breaks.

⚠️ **Axis is the hard case.** A ₹1 crore/day cap binds no retail investor. Coding it
`restricted` would put it alongside Tata, which accepted zero lumpsum. See D32.

### Finding 6 — fund houses loosen during crashes and tighten during rallies

The opposite of what "restriction protects investors in a fall" would predict:

- **SBI** removed SIP/STP restrictions 08-May-2020, mid-COVID crash; re-imposed 08-Sep-2020 as
  markets recovered; **raised** the cap ₹5,000 → ₹25,000 in Feb 2021
- **DSP** was closed 2017–2020 and **fully reopened 01-Apr-2020**, at the COVID bottom
- **Axis** cut its cap ₹2 cr → ₹5 lakh on 11-Mar-2020, then **raised it to ₹1 cr three weeks
  later** on 01-Apr-2020
- Business Standard (Feb 2020) reports limits were **relaxed during the 2018 correction**

Restrictions are a **valuation/capacity tool**, not a crash-protection tool. This matters for
how the finding is framed.

### Finding 7 — the parameters look coordinated, not independent

| | Lumpsum cap | SIP cap | Breach handling |
|---|---|---|---|
| Kotak (04-Mar) | ₹2,00,000/mo | ₹25,000/mo | rejected in full, no partial |
| Franklin (18-Mar) | ₹2,00,000/mo | ₹50,000/mo | rejected in full, no partial |
| ICICI Pru (14-Mar) | suspended | ₹2,00,000/mo | rejected in full, no partial |

Kotak and SBI share an identical ₹25,000/month SIP cap **with identical per-frequency
breakdowns** (₹1,250 daily / ₹6,250 weekly / ₹75,000 quarterly), word for word, four years apart.
Nippon and Motilal Oswal revised small-cap exit load to 1%-within-1-year in the same week.

⚠️ **This threatens the independence assumption in difference-in-differences.** See D33.

### Prior restriction history is widespread, not a Nippon quirk

| AMC | Prior episode | Outcome |
|---|---|---|
| DSP | capped 2014, cut 2016, **closed Feb 2017**, SIP-only Sep 2018 | **fully reopened 01-Apr-2020** |
| SBI | Mar 2020 notice, restrictions removed 08-May-2020, **re-imposed 08-Sep-2020** | still closed |
| Axis | ₹2 cr (Jan 2020) → ₹5 L (Mar 2020) → ₹1 cr (Apr 2020) → ₹5 L (Oct 2021) → ₹1 cr (May 2023) | ₹1 cr, nominal |
| PGIM | ₹10 L cap eff. 02-Aug-2021 (No. 15 of 2021-22) | **withdrawn eff. 01-Sep-2021** (No. 18) |
| Edelweiss | capped Recently Listed IPO Fund at ₹1 L/day/PAN, Jan 2022 | different scheme |
| Nippon | ⚠️ see correction below | |

**DSP, PGIM and Edelweiss are the strongest controls in the table** — fund houses that have
demonstrably used the mechanism and chose not to in 2024.

### 🔴 CORRECTION — Nippon's July 2023 restriction was NOT its first

Business Standard, **16 Feb 2020**: Nippon India Small Cap Fund had *already* barred lumpsum
and capped SIP/STP at **₹5 lakh monthly instalments**. There is therefore an earlier restriction
and an unlocated reopening between 2020 and July 2023.

Part 14's timeline starting at 07-Jul-2023 is **incomplete**. The widely repeated line that
Nippon "first placed restrictions in July 2023" — including in Business Standard's own March
2024 coverage — is wrong.

Does not change the Feb 2024 state or the analysis. Does mean the Nippon pre-history is deeper
than recorded.

### Dating the July 2023 wave precisely

Business Standard, **08 Jun 2023**, on HDFC Defence Fund: small-cap subscription restrictions
were then in force at **SBI Small Cap Fund and Mirae Asset Emerging Bluechip Fund** — and no
others named. Tata restricted 01-Jul-2023 and Nippon 07-Jul-2023.

So as of early June 2023, SBI was the only restricted major small-cap fund. The July 2023 wave
began immediately after.

### Archive structures — practical notes for any future sweep

**No two AMCs are alike.** There is no generic path, no generic numbering, no predictable
filename anywhere.

**Working URLs (verified 27–29 Aug 2026):**

| AMC | Addenda page |
|---|---|
| Nippon | `/investor-service/quick-links/notice-addendum` (**not** `/downloads/` — stale, ends 2022) |
| Tata | `tatamutualfund.com/notice-addendum/tmf` (JS-rendered; `/cams` is a different list) |
| SBI | `sbimf.com/notice-and-addendums` (type filter: **Scheme Information**; date range from 2020) |
| Kotak | addenda under `/Information/forms-and-downloads/`, **separate from** the Notices accordion on `/Information/statutory-disclosure` |
| ABSL | `mutualfund.adityabirlacapital.com/forms-and-downloads/addendums` |
| Axis | `axismf.com/statutory-disclosures` → section 6 |
| Bandhan | `bandhanmutual.com/downloads/addendums` |
| BOI | `boimf.in` → Regulatory Updates; PDFs at `/docs/default-source/reports/addenda-notice/` |
| Baroda BNP | `barodabnpparibasmf.in/downloads/notice-cum-addenda` |
| Canara Robeco | `canararobeco.com/forms-downloads/notice-cum-addendum` (F.Y. filter) |
| DSP | `dspim.com/downloads?category=Notices and Addendum&sub_category=Addendum` |
| Edelweiss | `edelweissmf.com/downloads/notice-cum-addendum` (**two** sections: Notice Cum Addendum *and* Notices) |
| Franklin | `franklintempletonindia.com/downloads/updates` |
| HDFC | `hdfcfund.com/statutory-disclosure/form-disclosures/addenda-notices` |
| HSBC | `assetmanagement.hsbc.co.in` → Downloads → **"Notice Ads"** |
| ICICI Pru | `icicipruamc.com/media-center/announcements` (⚠️ `archive.icicipruamc.com` is **dead**) |
| Invesco | `invescomutualfund.com/literature-and-form?tab=Addendums` |
| ITI | `itiamc.com/downloads` |
| Mahindra Manulife | `mahindramanulife.com/downloads#mandatory-disclosures` |
| PGIM | `pgimindia.com/mutual-funds/disclosures` → Addenda & Notices (⚠️ `pgimindiamf.idealake.com` is **dead**) |
| Sundaram | `sundarammutual.com/addendum-notice` |
| UTI | `utimf.com/downloads/addenda-financial-year` |
| Union | `unionmf.com/about-us/downloads` → SID/SAI/Addendum (⚠️ `/downloads/addendumsnotices.aspx` is the **old dead site**) |
| quant | `quantmutual.com/downloads/addendum` (year selector, 2008–present) |

**Numbering conventions — four different systems:**
- **Financial year**, continuous: BOI (`12/2023-24`), Axis (`43/2020-21`), PGIM (`No. 15 of 2021-22`)
- **Calendar year**: Baroda BNP (`68/2026`), Mahindra Manulife (`16/2025`)
- **Calendar MONTH**: ICICI Pru (`007/03/2024` = 7th addendum of March 2024) — sequence cannot
  be walked across a year
- **None at all**: most others

⚠️ Axis numbering resets each financial year — `40` and `43` are **not** adjacent if they sit in
different FY series. This cost time.

**Scanned PDFs with no text layer:** SBI's 2020–21 addenda are images. Needs OCR or manual
transcription. Only AMC where this occurred.

### ⚠️ The overseas-fund false positive — hit at FIVE AMCs

Subscription suspensions on **overseas/international schemes** use language nearly identical to
small-cap restrictions and cluster in the same months, driven by RBI overseas investment limits
(SEBI email 28-Jan-2022; a separate **AMFI email of 20-Mar-2024**).

Encountered and cleared at:

| AMC | Document | Actually covers |
|---|---|---|
| Nippon | Addendum 84, 22-Feb-2024 | US Equity Opportunities, Japan Equity, Taiwan Equity, ETF Hang Seng BeES |
| ABSL | Addendum 17/2024, 26-Mar-2024 | NASDAQ 100 FOF, US Treasury 1–3yr FoF, US Treasury 3–10yr FoF |
| ABSL | Addendum 08/2024, 13-Feb-2024 | International Equity Fund (₹1 cr/day/PAN) |
| HSBC, Invesco, PGIM, Axis, Franklin | various, 2022 & 2024 | overseas FoF schemes |

**ALWAYS read the scheme names.** Nippon's 22-Feb-2024 notice sits five days before the SEBI
email and would have moved the event date if taken at face value.

⚠️ **Two separate AMFI communications in 2024:** 27-Feb (small/mid cap policy) and 20-Mar
(overseas limits). Do not conflate them.

### Proof-of-inclusion — how each `not_restricted` was made defensible

An absence in an archive is weak. These are the documents that made the negatives strong:

| AMC | Evidence |
|---|---|
| **HDFC** | 🔴 restricted **two other schemes** in-window — Defence Fund (eff. 12-Jun-2023) and NIFTY Realty Index Fund (eff. 08-Apr-2024), both lumpsum-discontinued + SIP-capped. Chose not to for small cap |
| **ABSL** | 11-Mar-2024 addendum **lowered** minimum SIP to ₹100 across 25 schemes, Small Cap Fund named |
| **Edelweiss** | 06-Nov-2023 addendum, eff. 10-Nov-2023, minimums cut to ₹100, Small Cap Fund named |
| **BOI** | 23-Jun-2022 SIP Shield discontinuation names Bank of India Small Cap Fund |
| **SBI** | Dec-2024 "Discontinuation of Subscription in SBI International Access – US Equity FoF" proves suspensions file in this feed |
| **Invesco** | SID dated 30-Jun-2024 — post-event, no subscription-limit clause |
| **Canara Robeco** | KIM dated Nov-2024 — post-event, no subscription-limit clause |
| **HSBC** | April 2024 fund one-pager — **marketing** material for the small cap fund, published a month after the SEBI email |

⚠️ The ₹100-minimum moves at ABSL, Edelweiss, DSP, Invesco and Sundaram look like an
**industry-wide shift to micro-ticket investing**, not small-cap-specific intent. Good
proof-of-inclusion; weak evidence of intent.

### Confidence by row

**High** — archive walked + cross-checked: SBI, Tata, Nippon, Kotak, ICICI Pru, Franklin, ABSL,
Bandhan, BOI, Baroda BNP, Canara Robeco, DSP, Edelweiss, HDFC, Invesco, ITI, Mahindra Manulife,
PGIM, Sundaram, Union, quant

**Medium-high** — archive not fully reachable, rests on SID/KIM + third-party + absence from
reporting: **HSBC** (addenda listing unreachable), **UTI** (partial scan)

**Special**: **Axis** — the 15-May-2023 revision to ₹1 crore is sourced from a **fund PPT**, not
the addendum; the addendum was not locatable on the Addendums & Notices page. Confidence medium.

### Scheme renames and mergers — six cases for `core.scheme_lineage`

| Now | Previously | When |
|---|---|---|
| Bandhan Small Cap Fund | IDFC Small Cap Fund | Bandhan acquired IDFC MF, Jan 2023 |
| Bank of India Small Cap Fund | BOI AXA Small Cap Fund | Oct 2022 |
| HSBC Small Cap Fund | L&T Emerging Businesses Fund | HSBC absorbed L&T MF, late 2022 |
| Union Small Cap Fund | Union Small and Midcap Fund | recategorisation |
| Baroda BNP Paribas | Baroda MF + BNP Paribas MF merger | 2022 |
| Sundaram | absorbed Principal Mutual Fund | late 2021 |

Also: **HDFC Small Cap Fund** descends from Morgan Stanley Growth Fund; **Franklin India Smaller
Companies Fund** appears in some sources as "Franklin India Small Cap Fund".

### ⚠️ Inception dates — two funds cannot support a before-and-after

| AMC | Inception | Pre-period to 29-Feb-2024 |
|---|---|---|
| **Baroda BNP Paribas** | **30-Oct-2023** (allotment; NFO opened 06-Oct) | **4 months** — exclude from Q2/Q3 |
| **Mahindra Manulife** | **12-Dec-2022** | 14 months — usable but thin |
| PGIM | ~Jul 2021 | ~2.5 years |
| UTI | Dec 2020 | ~3.2 years |
| ITI | 14-Feb-2020 (disputed) | ~4 years |

**Run an inception-date filter against `core.schemes` before the analysis.** Any scheme launched
close to the event has no baseline.

### ⚠️ Do not use Groww for inception dates or scheme AUM

Wrong on **at least six** AMCs in this sweep. It reports **fund-house-level AUM in the scheme
field** and **predecessor-scheme launch dates**:

| Fund | Groww AUM | Actual | Groww launch | Actual |
|---|---|---|---|---|
| Edelweiss Small Cap | ₹1,72,784 cr | ~₹5,481 cr | — | — |
| Invesco Smallcap | ₹1,60,871 cr | ~₹11,717 cr | 24-Jul-2006 | 30-Oct-2018 |
| UTI Small Cap | ₹4,04,286 cr | ~₹4,872 cr | — | 22-Dec-2020 |
| Mahindra Manulife Small Cap | ₹37,713 cr | ~₹5,087 cr | 04-Feb-2016 | 12-Dec-2022 |
| Union Small Cap | ₹27,363 cr | ~₹2,268 cr | 30-Dec-2009 | 10-Jun-2014 |
| quant Small Cap | ₹1,03,143 cr | ~₹30,000 cr | 15-Apr-1996 | — |
| HSBC Small Cap | ₹1,51,232 cr | — | 27-May-2002 | (L&T predecessor) |

**Use `core.schemes` and AMFI. Value Research and MySIPonline were reliable throughout.**

### Structural facts for the restriction table schema

- **One addendum can carry several restriction types** with one effective date
  (Nippon no. 94: exit load *and* SIP cap; Kotak 26-Feb: lumpsum *and* SIP caps)
- **A corrigendum can supersede a clause the same day** (Nippon, 06-Jul-2023)
- **One change can require two addenda** — DSP filed separate SID and KIM amendments on
  25-Mar-2020 for the same reopening. **Document count ≠ event count**
- **A restriction can be partially modified** — ICICI restored Freedom SIP on 05-Jul-2024
  while everything else stayed suspended
- **Publication date ≠ effective date**, routinely: Tata 26-Jun → 01-Jul-2023 (5 days),
  Kotak 26-Feb → 04-Mar-2024 (7 days), ICICI 12-Mar → 14-Mar-2024
- Nippon and Franklin both use "shall **continue** with a limit of Rs X" while **changing** the
  number. **Compare the numbers, not the verbs**

### Full restriction lifecycles — the two most analytically useful rows

**Kotak** — the only complete open→closed→open cycle inside the window:
- eff. 04-Mar-2024: lumpsum ₹2,00,000/mo, SIP/STP ₹25,000/mo
- eff. 02-Jul-2024: **all limits removed**, fully reopened

**ICICI Prudential** — imposed, partially relaxed, fully lifted:
- eff. 14-Mar-2024 (No. 007/03/2024): lumpsum + switch-in **suspended**, SIP/STP ₹2 L/mo,
  special products withdrawn. Also covered **ICICI Prudential Midcap Fund** — the only
  midcap restriction in the sweep
- eff. 05-Jul-2024 (No. 003/07/2024): Freedom SIP restored, monthly only
- eff. 23-Jan-2026 (No. 009/01/2026): **all restrictions withdrawn** — 22 months closed.
  ⚠️ this final addendum names **only** the Smallcap Fund; midcap status unverified

ICICI is also the only AMC to state a **reopening condition** in the original addendum: lumpsum
may be accepted "when in its assessment the valuations become attractive."

---

## PART 16 — STUDY UNIVERSE, RESTRICTION TABLE, AND Q2 ANSWERED (1 September 2026)

### The name-matching problem, quantified

Matching `core.schemes.scheme_name` for small cap variants returns **297 rows**. Adding a filter
for codes with NAV rows in 2023–2025 cuts it to **210**. The target is 24.

What the 210 contains besides the 24: Nifty Smallcap 250/50 index funds and ETFs from nearly
every fund house, eight AMCs outside the universe (Groww, JM, LIC MF, Mirae, Motilal Oswal,
Quantum, TRUSTMF, IDBI), the Sundaram Emerging Small Cap Series I–VII, and Bank of India's
Mid & Small Cap Equity & Debt hybrid.

**All 24 fund houses were present** — recall was 100%, precision about 11%. The earlier
expectation that name-matching would miss several was wrong; the problem is the opposite.

### 🔴 Ten naming conventions for one concept

Across 24 funds the archive writes "Direct plan, Growth option" as: `Direct Plan - Growth`,
`Growth - Direct Plan`, `DIRECT PLAN GROWTH`, `Direct Plan Growth`, `Growth Option - Direct
Plan`, `Direct Growth`, `Growth - Direct`, `Direct-Plan-Growth`, `Direct Plan- Growth Option`,
and `Direct Plan Growth Plan - Growth Option`.

**No filter separates them reliably, and a wrong filter returns 24 rows too.** That is the
argument for the curated table: the pattern generates candidates, a human picks.

Specific traps found:

| Trap | Detail |
|---|---|
| **Nippon Bonus option** | `118777` Bonus sits beside `118778` Growth; both names contain "Direct Plan Growth Plan". A filter on `%direct%` AND `%growth%` returns **both** |
| **quant vs QUANTUM** | `120828` quant, `152107` QUANTUM — different fund houses |
| **Kotak** | `Kotak-Small Cap Fund` — hyphen, no space. "Kotak Small Cap" matches nothing |
| **Franklin** | Direct is `118525`; `103360` carries a similar name but is Regular |
| **BOI** | Also runs Mid & Small Cap Equity & Debt Fund, a hybrid |
| **Sundaram** | Open-ended fund shares a name stem with closed-ended Emerging and Select series |

### ⚠️ The archive's names are current, the addenda's names are historical

`103360` is labelled **Franklin India Small Cap Fund** in the archive, while the March 2024
addendum says **Smaller Companies Fund**. The fund was renamed *after* the filing and the
archive rewrote the name against the existing code.

So matching addendum text against archive text fails for any fund renamed in between, silently.
`study_universe.scheme_name` stores the archive name as verified, deliberately **not** as a
foreign key.

### `core.schemes` has two columns only

`scheme_code` and `scheme_name`. No AMC, no category, no plan, no option, no inception date, no
active flag. Everything must be derived from the name string or from NAV coverage.

### The verified 24

| AMC | Code | AMC | Code |
|---|---|---|---|
| absl | 119556 | invesco | 145137 |
| axis | 125354 | iti | 147919 |
| bandhan | 147946 | kotak | 120164 |
| boi | 145678 | mahindra | 150915 |
| barodabnp | 152128 | nippon | 118778 |
| canara | 146130 | pgim | 149019 |
| dsp | 119212 | sbi | 125497 |
| edelweiss | 146196 | sundaram | 119589 |
| franklin | 118525 | tata | 145206 |
| hdfc | 130503 | uti | 148618 |
| hsbc | 151130 | union | 129649 |
| icici | 120591 | quant | 120828 |

### NAV coverage — the slice, not the funds

`MIN(nav_date)` is **2022-01-03** for 21 of 24 funds. That is the first trading day of the
loaded slice, **not** an inception date. The full 36.7M-row archive back to 2006 is still
unloaded.

Three funds start later, and those dates are real:

| AMC | First NAV | Rows | Meaning |
|---|---|---|---|
| hsbc | 2022-11-28 | 911 | L&T merger — scheme recoded, not launched |
| mahindra | 2022-12-14 | 899 | inception 12-Dec-2022 |
| barodabnp | **2023-11-01** | **682** | allotment 30-Oct-2023 — **4 months of pre-period** |

Row counts of ~1,133 over 4.6 years ≈ 246/year, a normal Indian trading calendar. No gaps.
All 24 run to 2026-08-14.

**Usable pre-period is Jan 2022 – Feb 2024, about 26 months.** See D36.

### Postgres gotchas hit during the build

- **`nav.date` is `nav_date` in Postgres**, not `date` as in the SQLite source. First divergence
  between the two schemas
- **`ROUND(double precision, integer)` does not exist.** Two-argument `ROUND` is numeric-only.
  Cast the whole expression: `ROUND((expr)::numeric, 2)`. Same class as `MONTH()` vs `EXTRACT()`
- **`UNIQUE KEY` is MySQL.** Postgres wants `UNIQUE`
- **`DISTINCT ON` and `MAX()` are alternatives, not partners.** `DISTINCT ON` returns the whole
  row associated with an extreme value, which `MAX()` cannot
- **A LEFT JOIN date filter must sit in `ON`, not `WHERE`.** In `WHERE` it discards unmatched
  rows and silently reduces the join to an inner one
- A **schema created by `ALTER DATABASE ... SET search_path`** takes effect on the next
  connection, not the current one

---

## 🔴 Q2 ANSWERED — DRAWDOWN BY FUND

### Every fund troughed on 13 March 2024

**All 24. Not one exception.** Different portfolios, concentrations and cash positions; the
bottom did not move by a single day. This was one market-wide event, not 24 fund-specific ones.

### Peaks were NOT synchronised

Fifteen funds peaked **6–7 February 2024**, three weeks before the regulatory communication.
Nine peaked **23–27 February** — DSP on the 26th; Franklin, ICICI, SBI and PGIM on the 27th,
the day of the SEBI email itself, still making highs as the regulator acted.

### The full result

| Rank | AMC | Lumpsum state | Peak | Drawdown |
|---|---|---|---|---|
| 1 | barodabnp | open | 06-Feb | **−11.30%** |
| 2 | union | open | 07-Feb | −11.16% |
| 3 | hsbc | open | 07-Feb | −11.03% |
| 4 | quant | open | 23-Feb | −11.02% |
| 5 | **tata** | **suspended** | 26-Feb | **−10.75%** |
| 6 | uti | open | 07-Feb | −10.50% |
| 7 | mahindra | open | 06-Feb | −10.31% |
| 8 | bandhan | open | 07-Feb | −10.30% |
| 9 | invesco | open | 07-Feb | −10.03% |
| 10 | boi | open | 07-Feb | −10.00% |
| 11 | dsp | open (prev. restricted) | 26-Feb | −9.77% |
| 12 | iti | open | 23-Feb | −9.73% |
| 13 | canara | open | 07-Feb | −9.28% |
| 14 | absl | open | 07-Feb | −9.22% |
| 15 | hdfc | open | 06-Feb | −9.16% |
| 16 | edelweiss | open | 07-Feb | −8.87% |
| 17 | **axis** | **capped (nominal)** | 07-Feb | −8.58% |
| 18 | sundaram | open | 07-Feb | −8.58% |
| 19 | pgim | open (prev. restricted) | 27-Feb | −8.57% |
| 20 | **nippon** | **suspended** | 07-Feb | −8.38% |
| 21 | franklin | open | 27-Feb | −8.17% |
| 22 | kotak | open | 07-Feb | −7.94% |
| 23 | icici | open | 27-Feb | −7.91% |
| 24 | **sbi** | **suspended** | 27-Feb | **−6.17%** |

### 🔴 Restriction status does NOT sort the drawdowns

The three funds closed to lumpsum on the event date rank **1st, 5th and 20th of 24**:

- **SBI −6.17%** — the shallowest fall in the entire universe, and the most heavily restricted
  fund (closed since 2020, SIP capped at ₹25,000/month)
- **Nippon −8.38%** — 20th, in the shallow half
- **Tata −10.75%** — 5th deepest, also closed to lumpsum

The treated group spans nearly the full range of the control group. The whole distribution is
only 5.1 percentage points wide, −6.17% to −11.30%.

**With n=3 treated, no group effect could be established even if one existed.** The honest
statement is that restriction status does not explain the variation — which is consistent with
the timing finding in Part 15: three of the four in-window restrictions took effect *after* the
13 March trough.

### 🔬 Untested — peak date may matter more than restriction status

The shallowest falls cluster among funds that peaked **latest**. Of the six shallowest
(sundaram, pgim, nippon, franklin, kotak, icici), four peaked 26–27 February. Of the ten
deepest, seven peaked 6–7 February.

Counterintuitive: a fund that peaked later had less time to fall *and* fell less. Suggests
portfolio composition — which small caps rolled over when — rather than subscription policy.

**Testable directly from the existing view.** Correlate `peak_date` against `drawdown_pct`.

### ⚠️ The peak window bound is a judgement, and the first attempt got it wrong

An initial run searched peaks over 01-Jan to 30-Apr-2024 and returned **30 April as the peak
date for 23 of 24 funds** — every fund had recovered past its pre-event high by then.

That is itself a finding: **the correction was fully retraced within roughly seven weeks.**

The peak window was cut to end **29 February**. A fund peaking in early March would be clipped;
none was — the latest peak is 27 February. State the bound; do not hide it.

---

## PART 17 — Q3 ANSWERED: THE RECOVERY (1 September 2026)

Anchored to the 13 March 2024 trough, which every fund shares. **This is the cleanest
comparison in the project** — unlike the drawdown columns, which carry a runway artefact from
the three-week spread in peak dates, all 24 funds start the recovery clock on the same day.

### Every fund recovered

All 24 regained their pre-event high. None failed to. The measure is the first trading day after
13 March on which NAV reached or exceeded that fund's own February peak.

### 🔴 Two groups, with a clean gap

| Group | n | Days | Recovery date |
|---|---|---|---|
| Fast | 20 | **19–28** (most 21–23) | 1–10 April 2024 |
| **Slow** | **4** | **42–43** | **24–25 April 2024** |

**Nothing falls between 28 and 42 days.** The gap is real, not a tail.

**The slow four: Axis (42), Baroda BNP (42), Union (43), UTI (43).**

### Full result

| AMC | Drawdown | Days | AMC | Drawdown | Days |
|---|---|---|---|---|---|
| **sbi** | −6.17% | **19** | absl | −9.22% | 23 |
| **iti** | −9.73% | **19** | boi | −10.00% | 23 |
| **nippon** | −8.38% | **20** | hdfc | −9.16% | 23 |
| edelweiss | −8.87% | 21 | quant | −11.02% | 23 |
| franklin | −8.17% | 21 | dsp | −9.77% | 28 |
| kotak | −7.94% | 21 | hsbc | −11.03% | 28 |
| bandhan | −10.30% | 22 | **axis** | −8.58% | **42** |
| canara | −9.28% | 22 | **barodabnp** | −11.30% | **42** |
| icici | −7.91% | 22 | **union** | −11.16% | **43** |
| invesco | −10.03% | 22 | **uti** | −10.50% | **43** |
| mahindra | −10.31% | 22 | | | |
| pgim | −8.57% | 22 | | | |
| sundaram | −8.58% | 22 | | | |
| tata | −10.75% | 22 | | | |

### Depth explains part of it, and not most

**Correlation between drawdown and days to recover: r = −0.45** across all 24. Shallower falls do
return sooner. But **r² ≈ 0.20** — roughly four fifths of the variation in recovery speed is
unexplained by how far the fund fell.

Among the eight deepest falls, recovery ranges **22 to 43 days**. Depth is not destiny.

### 🔴 Restriction status does not explain recovery either

| AMC | Drawdown (rank) | Days (rank) | Reading |
|---|---|---|---|
| SBI | −6.17% (24th, shallowest) | 19 (2nd fastest) | **on the line** |
| Nippon | −8.38% (20th) | 20 (3rd) | on the line, marginally better |
| Tata | −10.75% (5th deepest) | 22 (14th) | **above the line** |

**SBI is fast because it fell least, not because it was restricted.** It sits exactly where the
depth relationship predicts; there is no residual for restriction to explain. This was the
specific question tested and the answer is clean.

**Tata is the genuine deviation.** It fell as hard as the slow group and recovered with the fast
one:

| | Drawdown | Days |
|---|---|---|
| barodabnp | −11.30% | 42 |
| union | −11.16% | 43 |
| **tata** | **−10.75%** | **22** |
| uti | −10.50% | 43 |

⚠️ **But five unrestricted funds did the same.** quant (−11.02%, 23 days), hsbc (−11.03%, 28),
mahindra (−10.31%, 22), bandhan (−10.30%, 22), invesco (−10.03%, 22) all fell deeply and
recovered quickly. Tata is one case among six, not a pattern.

### 🔴 OPEN: what separates the four slow recoverers

Axis, Baroda BNP, Union, UTI. Checked and rejected as explanations:

- **Not depth.** Axis fell −8.58%, 17th of 24 — mid-pack, and tied slowest
- **Not restriction status.** Three were never restricted; Axis had only the nominal
  ₹1 crore/day cap
- **Not peak cluster.** All four peaked early (6–7 February), but so did twelve of the fast group
- **Not fund age.** Baroda BNP launched Oct 2023, Union in 2014, UTI in 2020, Axis in 2013

Nothing in the current data accounts for it. Candidate explanations that would need the stress
test files or portfolio data: cash position entering the correction, concentration, or overlap
in the specific small caps that lagged the rebound.

### Method note

`analysis.recovery_by_fund` depends on `analysis.drawdown_by_fund`, which depends on
`analysis.fund_state_at_event`. Three levels. Dropping the base view needs CASCADE, and a
rebuild runs 001, 002, 003 in order.
