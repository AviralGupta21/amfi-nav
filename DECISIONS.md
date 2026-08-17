# DECISIONS.md — Project Decisions & Reasoning

**Project:** AMFI mutual fund data pipeline + Feb–Mar 2024 small-cap event analysis
**Purpose:** Every decision with its *reasoning*. In an interview, the reasoning is the answer.
**Last updated:** 17 August 2026

---

## D1 — Build a mutual fund database project at all
**Decision:** Yes.
**Reasoning:** A LinkedIn posting from an AMC explicitly asked for someone who has worked
with a real database, built a real pipeline, and handled mutual fund data. This project
targets that requirement directly rather than being a generic portfolio piece.

---

## D2 — Reconciliation / data quality over "AI agentic anomaly detection"
**Decision:** Frame the project as a **data quality and reconciliation engine**, not an
ML anomaly-detection exercise.

**Reasoning:**
- EDA is commoditised. Anyone can produce a correlation heatmap with an LLM in ten minutes.
  "I did EDA on a Kaggle dataset" is now worth roughly zero.
- What survived commoditisation is data engineering rigour: ingestion, schema design,
  reconciliation, handling broken data.
- **What AMC/PMS data teams actually do all day is reconciliation** — NAV files that don't
  match, corporate actions breaking return series, scheme mergers orphaning history,
  Direct/Regular and Growth/IDCW share classes getting double-counted.
- Anomaly detection framed as ML is a solution looking for a problem here. Framed as
  reconciliation, it's literally the job.

**Interview framing:** lead with "I built a reconciliation layer over AMFI data; here are the
seven categories of data defects it catches, with counts." NOT "I built an AI agentic pipeline."

---

## D3 — Where AI legitimately belongs (and where it doesn't)
**Decision:** LLM use is limited to **parsing heterogeneous AMC disclosure files** (schema
mapping across inconsistent formats). Optionally a natural-language query layer. Thin layer,
clearly justified, **not the spine.**

**Reasoning:** Every AMC formats monthly portfolio disclosures differently. Schema mapping
across inconsistent formats is a genuine LLM use case with a defensible reason to exist.
Mention it as an implementation detail when asked, not as the headline.

**Caution:** Capitalmind and most AMC data teams are explicitly rules-based and evidence-first.
They have been burned by black boxes and they audit everything. Leading with "AI agentic
pipeline" will land badly.

---

## D4 — Scope: DROP monthly portfolio disclosures from v1
**Decision:** v1 = NAV history + scheme dimension + quality checks. Portfolio disclosures
become v2.

**Reasoning:** 40+ AMCs each using a different Excel layout is a multi-week ingestion problem
on its own. ~45 hours doesn't cover it. NAV history + scheme dimension + checks is a complete,
defensible project standalone.

**Bonus:** "Phase 2 in progress" is an honest and good interview answer — and v2 is exactly
where the LLM parsing earns its place.

---

## D5 — Primary event: Small-cap stress testing & AMC inflow restrictions (Feb–Mar 2024)
**Decision:** Primary chapter. Secondary chapter = F&O cost/structure changes (Oct 2024+)
if time allows.

**Reasoning for choosing this over alternatives:**

| Candidate event | Verdict |
|---|---|
| Debt fund indexation removal (1 Apr 2023) | Cleanest date, biggest effect, most data — **but the most-written-about event of the decade.** You'd be re-finding a known result |
| **Small-cap stress test (Feb–Mar 2024)** | ✅ **CHOSEN** |
| F&O cost/structure changes (Oct 2024+) | Good, under-analysed, ties to arbitrage — **secondary chapter** |
| Budget 2024 capital gains (23 Jul 2024) | Moved everything at once → no clean control group. **Skipped** |
| SEBI MF Regulations 2026 (1 Apr 2026) | Maximally current, but only ~4.5 months of data and cost effects are ~5–7bp/year — undetectable against NAV noise. **Skipped for v1** |

**Why #2 wins:** it is the only candidate where "why did one company behave differently?"
is *baked in* rather than something you have to hunt for. AMCs faced the same rule, the same
date, the same market — and made publicly documented, divergent choices. That's a natural
experiment.

---

## D6 — Secondary event kept as arbitrage/F&O (not something else)
**Decision:** F&O cost and structure changes, Oct 2024 onward.

**Reasoning:** Clean dates. Clean treated group (arbitrage funds) vs clean control group
(liquid, ultra-short, money market — same investor use case, no derivatives exposure).
Under-analysed relative to the 2023 tax event. Also makes the Aug 2026 Closing Auction Session
(CAS) event a natural "here's my v2 extension" answer in an interview.

**Known weakness:** smaller effect, needs care to separate from the rate cycle.

---

## D7 — Analysis must have a control group
**Decision:** Every finding compares treated vs control, before vs after.

**Reasoning:** If small-cap fund returns changed after the event — so what? Maybe all funds
changed. Without a control group you cannot attribute anything. This is difference-in-differences;
the name is harder than the idea.

---

## D8 — Verify from primary sources, not news articles
**Decision:** Build the AMC restriction table from **each AMC's own addenda/notices pages**.
News coverage is a starting point, not a citation.

**Reasoning:** Regulatory dates and implementation phases get reported loosely. Three weeks of
work resting on a misremembered date would be painful. Slower, but it's the difference between
a project built on facts and one built on someone's summary.

---

## D9 — Timeline: start 19–20 Aug, ~2–3 hrs/day, target early September
**Decision:** Roughly 45 hours over ~16 days.

**Indicative plan (revised 17 Aug 2026 — see D22):**
- Days 1–3: domain concepts; NAV archive download and inspection; raw load
- Days 4–5: **narrow scheme resolution** — codes for the treated and control schemes only,
  not a general parser. ⚠️ *Originally budgeted days 4–7 for a full scheme dimension across all
  38,107 codes. That was oversized — see D22*
- Days 6–12: the checks — stale NAV, Direct-Regular spread inversions, impossible single-day
  moves, missing business days, scheme code discontinuities
- Days 13–16: validate against 2–3 independently verifiable real events; README; defect counts
  by category
- **Days freed from parsing go to the analysis**, not to extending the parser

**Expect a "the data is weirder than I thought" wall around day 6.** Every AMFI project hits it.
Budget for it rather than treating it as failure.

---

## D10 — Power BI: yes, but LAST and small
**Decision:** Add ~2–3 days *after* the core pipeline is complete (first week of September).

**Reasoning:**
- Power BI is a **keyword filter** as much as a skill. Indian analyst JDs list it constantly
  and recruiter screening is often literal keyword matching before a human reads anything.
- Attached to a real project it beats a certification.
- Gives something to show on a screen share.

**Scope:** one dashboard, 3–4 pages max — data quality summary with defect counts by category,
drill-through to individual flagged rows, Direct-vs-Regular expense drag across a few fund houses.
Just enough DAX for a handful of measures. **Do not go down the DAX rabbit hole.**

**Connect live to Postgres via the native connector — NOT a CSV export.** The live connection is
what demonstrates pipeline thinking rather than dashboard decoration.

**Framing:** the dashboard is the *output layer of a pipeline*, not the project. Candidates who
lead with Power BI usually have nothing underneath it. This is the reverse of what interviewers
are used to seeing.

---

## D11 — Native Windows PostgreSQL, NOT WSL2
**Decision:** Native Windows installer.

**Reasoning:** WSL works fine for the database itself, but Power BI connecting to a WSL-hosted
Postgres involves networking friction you don't want to debug in week three.

**Hardware (Dell G15 5520):** i5-12500H, 12 cores, 16 GB RAM, RTX 3050, ~122 GB free.
Estimated data size: ~25–40M rows, ~5–10 GB with indexes. **Not close to a constraint.**
GPU is irrelevant — Postgres won't touch it.

---

## D12 — Loading and tuning decisions
| Decision | Reasoning |
|---|---|
| Use **`COPY`**, never row-by-row `INSERT` | Difference between ~4 minutes and ~4 hours on 30M rows. Without this you'll think the laptop is the problem when it isn't. **But use `\copy`, not `COPY` — see D18** |
| **Create indexes AFTER the load**, not before | Loading into an indexed table means Postgres maintains the index on every single row |
| Raise **`shared_buffers` to 2–4 GB** | Default is 128 MB — absurdly conservative for a 16 GB machine |
| Raise **`maintenance_work_mem`** before building indexes | Dramatically faster index creation |
| Clear disk space before starting | Raw downloads + database + Power BI local model all live on the same drive |

*→ These decisions are themselves an interview answer. Size estimation, choosing `COPY`,
deliberately tuning `shared_buffers` — that's what separates "I loaded a CSV into a database"
from "I built a pipeline."*

---

## D13 — Working method: Aviral writes all code
**Decision:** Claude explains finance and reasoning on request. Aviral writes the code.

**Reasoning:** If Claude writes the SQL, the project ships on time and then freezes when an
interviewer asks "why did your stale-NAV check fire on this particular scheme?" The interview
test isn't whether the project is impressive — it's whether you can defend a specific flagged row.

---

## D14 — Pre-session expectation-setting as the learning mechanism
**Decision:** Before writing code each session, state what you expect to see and why.
If the prediction is wrong, stop and determine whether the data is weird or your model of the
world is wrong.

**Reasoning:** This is what builds the understanding. It beats pre-loading concepts because it
forces commitment to a belief before checking. **Concepts only come "for free" while building
if you deliberately stop and ask** — otherwise three weeks pass and you've learned Postgres
and no finance.

---

## D15 — Notes maintained by Claude, reviewed by Aviral
**Decision:** Claude drafts and updates NOTES.md and DECISIONS.md. Aviral stores them locally
and pastes them back at the start of each session.

**Reasoning:** Time crunch. Trade-off accepted knowingly.
**Mitigation:** read NOTES.md aloud before the interview and try explaining each concept
without looking. A file you didn't write is a file you haven't yet processed — the gaps will
show up immediately, and those are the ones to close.

**Process:** at the end of each session Claude flags "does this belong in NOTES.md or
DECISIONS.md?" Aviral confirms and pastes the current files back for updating.

---

## D16 — Claude has no persistent file access
**Fact, not a decision, but important:** there is no background process maintaining these files.
Claude cannot write to Aviral's machine. If this chat is lost, everything in it is gone unless
the files are saved locally.

---

## D17 — Version the code that builds the database, not the database
**Decision:** Git/GitHub tracks the build artifacts. The database itself is never committed.

**Reasoning:** Postgres has no concept of GitHub and a database doesn't belong in version
control. But a daily-updating public record of the project is exactly what's wanted — and you
get it by versioning the *code that builds* the database.

**Repo structure:**
```
sql/schema/     CREATE TABLE, index, and constraint definitions
sql/load/       COPY statements and staging/cleanup steps
sql/analysis/   the queries answering the small-cap stress-test questions
scripts/        Python to fetch AMFI files or orchestrate loading
README.md       the project narrative — arguably the most important file for a portfolio piece
notes/          findings as you go, so the analysis chapter writes itself later
```

**Never committed:**
- The Postgres data directory
- Raw AMFI dumps — hundreds of MB to GB, and **GitHub's limit is 100 MB per file**
- Any `.pgpass`, connection strings containing passwords, or `.env` files

**`.gitignore` — create BEFORE the first commit:**
```
data/
*.csv
*.env
.pgpass
__pycache__/
```

**The rule of thumb that defines success:** someone should be able to clone the repo, download
the AMFI data themselves, run the scripts in order, and end up with your database.
**That's what makes it a portfolio project rather than a screenshot.**

**Setup, once:**
```
cd C:\Users\<you>\projects\amfi-nav
git init
git remote add origin https://github.com/<you>/amfi-nav.git
```

**Daily:** `git add -A`, `git commit -m "..."`, `git push`. Green squares come from commits, so
committing at the end of each 2–3 hour session produces the daily cadence.

**Write meaningful commit messages.** "Added stress-test window filter for Feb–Mar 2024
small-cap flows" reads very differently to a hiring manager than "update".
**The commit log is a visible artifact of how you think.**

**Schema snapshots:** `pg_dump --schema-only` produces a text file that's small and diffs
cleanly. Run it whenever the schema changes.

---

## D18 — Use `\copy` (psql client-side), not `COPY` (server-side)
**Decision:** All bulk loading goes through `\copy` with a backslash.

**Reasoning:** The Postgres Windows service runs as **`NT AUTHORITY\NetworkService`**, not as
you. Server-side `COPY` reads files *as that account*, which has no access to your user folders.
So `COPY ... FROM 'C:\Users\<you>\projects\...'` fails with a permissions error that looks
confusing and unrelated to the actual cause.

`\copy` is a psql client-side command — it reads the file **as you**. Same performance at this
data size, no permission headaches.

*→ Worth knowing in advance so you don't lose twenty minutes to it mid-load.*

---

## D19 — Stress test files ARE in scope (scope change, 17 Aug 2026)
**Decision:** Ingest the AMC stress test disclosure files as a third data source alongside
NAV and the restriction table.

**Reasoning:** The Nippon retrieval test succeeded. The archive runs back to **February 2024**,
and the volume is small (~a few hundred rows across 12 AMCs × ~30 months × ~2 schemes).

⚠️ **Correction to an earlier version of this decision:** it claimed a "fully predictable URL
pattern." False — Nippon used **three different naming conventions across four consecutive
months**, including a different folder and a different file extension. **Harvest `href`
attributes from the page; do not construct URLs.** Assume nothing about the other 11 AMCs.

**Possible upgrade — CONFIRMED:** the 29-Feb-2024 file contains **real data**, giving a clean
pre-event baseline. It also carries an **AMFI Scheme Code** column (the join key to NAV data)
and an explicit portfolio date — both **absent** from the Apr/May/Jun files. Format drifts
within a single AMC over time, not just across AMCs.

**Two consequences:**

1. **Monthly scheme-level AUM is now available** for mid and small cap schemes (column B).
   The Part 8 constraint — that scheme-level AUM is quarterly only — is partly lifted for
   exactly the treated group. **The flow decomposition becomes computable monthly at scheme
   level.** This upgrades the analysis materially.

2. **The heterogeneous-format parsing problem arrives in v1, not v2.** Multi-row merged headers,
   old binary `.xls`, and each AMC laying it out differently. This is where D3's narrowly-scoped
   LLM parsing use case now legitimately lives — earlier than planned.

**Timing caveat — RESOLVED.** The 29-Feb file is real data, so a clean pre-event baseline exists
and the parameters can explain the **initial drop**, not just the recovery.

**Scope discipline:** this is an enrichment layer. If parsing 12 AMCs' formats proves slower than
expected, fall back to Nippon plus 3–4 others and say so honestly. The core analysis still runs
on NAV + restriction table alone.

---

## D20 — Build the scheme-code lookup from the February file
**Decision:** Extract the AMFI Scheme Code ↔ scheme name mapping from the 29-Feb-2024 file and
use it to key every later month's disclosure by name.

**Reasoning:** The Feb file is the **only** Nippon disclosure carrying AMFI Scheme Code. March
onward dropped it and start at Scheme Name. Without a mapping, every later file can only be
matched to NAV data by fund name — the unreliable route, and the exact failure mode this project
is meant to demonstrate competence against.

**The mapping table is itself a deliverable of the reconciliation layer**, not a workaround.

⚠️ **Verify granularity first** (NOTES.md Part 10): AMFI codes are normally per plan AND option,
but the disclosure gives one code per scheme alongside whole-scheme AUM. If 100377 resolves to a
single plan, a naive join would attribute total scheme AUM to one share class.

---

## D21 — Dual-source ingestion: clean archive for history, raw AMFI for the event window
**Decision:** Use the `captn3m0` SQLite archive as the historical backbone, **and ingest raw
AMFI text files directly for Feb–Jun 2024** — the analysis window.

**Reasoning:** The archive is pre-cleaned. Verified 17 Aug 2026: `typeof(nav)` = `real` and
`typeof(date)` = `text` for **all 36,765,864 rows**, one group each, zero exceptions. The
documented AMFI defects describe what AMFI *publishes*, not what survives the maintainer's import.

⚠️ **This corrects an earlier assumption** recorded in NOTES.md Part 8, which called those
defects "a gift for the reconciliation layer." Wrong for this source.

**Why dual-source rather than picking one:**
- The archive gives 36.7M rows of clean backbone for long-run context, cheaply
- Raw AMFI for the event window gives **authentic messy ingestion** where the analysis actually
  lives — and it is what an AMC data team would genuinely be handling

**Interview framing:** "I used a community archive for historical depth and went to the primary
source for the analysis window, because the archive had been pre-cleaned and I wanted the
pipeline to handle real input."

### Consequent reframing of the reconciliation layer
Type/format errors are trivial to catch — anyone can write a regex. **The defects worth building
for are semantic**, and they require domain knowledge to even define:
- Stale NAV — unchanged across consecutive business days
- Missing trading days
- **Direct plan priced below its Regular counterpart** (should be impossible — Direct has lower
  expenses, so its NAV should grow faster)
- Impossible single-day moves
- Orphaned `scheme_code` values violating the declared foreign keys
- Scheme code discontinuities at mergers

**This is a stronger project than string validation**, and it is closer to what D2 described as
the actual work of an AMC data team.

---

## D22 — Load everything, parse narrowly (scope correction, 17 Aug 2026)
**Decision:** Ingest all 36.7M NAV rows and all 38,107 scheme codes into PostgreSQL. **Parse
scheme names only for the schemes the analysis actually touches** — roughly 30–40 codes across
~12 AMCs, plus the control group.

**Reasoning — loading is not parsing, and they were conflated:**
- **Loading** is one `\copy` and some patience. It requires understanding zero scheme names.
  It's what makes this a data engineering project rather than a spreadsheet exercise, and it
  costs almost nothing
- **Parsing** names into a clean plan/option dimension is the expensive part. Doing it across
  all 38,107 codes means handling dead FMPs, Institutional plans and Bonus options from 2009 —
  **none of which touch a Feb–Mar 2024 event**

⚠️ **This corrects D9**, which budgeted days 4–7 for a general scheme dimension. That estimate
assumed a universal parser and was oversized.

### Why today's parsing work still paid for itself
The catalogue in NOTES.md Part 11 established that **codes are stable and names are not.**
That finding is what makes the narrow scope viable: pulling the **February 2024** disclosure
files from all 12 AMCs (the only month carrying the `AMFI Scheme Code` column) gives the codes
for every treated scheme directly. **No name matching needed for the core join.**

*→ The parsing problem can largely be routed around precisely because it was catalogued.*

### Where name work is still genuinely required (short list)
1. **Mar-2024-onward disclosure files dropped the scheme code column** → match on name, but only
   for ~12 known funds. That's a lookup table, not a parser
2. **Direct-vs-Regular checks** need the Direct code paired with the Regular code for the same
   scheme. Only the name connects them. Again ~12 funds
3. **Control group definition** — the one place broader name work may be needed, depending on
   how the group is drawn

⚠️ **Note the messy naming is INSIDE the event data, not off to the side of it.** Code 100377 —
handed over by the Feb 2024 disclosure — is itself a legacy name: `Nippon India Growth Mid Cap
Fund-Growth Plan-Growth Option`, no spaces around separators, no "Regular" token, two stacked
plan layers. It cannot be filtered out as a 2009 fossil.

**Document the filter as a deliberate scope decision** in the README rather than implying a
universal parser was built.

---

## OPEN / PENDING DECISIONS

- [x] **Is the historical stress test archive retrievable?** → **RESOLVED 17 Aug 2026: YES.**
      Nippon's archive runs back to March 2024 with a fully predictable URL pattern.
      **Stress test parameters are IN SCOPE**, and the files also supply monthly scheme-level
      AUM — see D19 and NOTES.md Part 10.
- [ ] Do the other 11 AMCs archive equally far back with equally predictable URLs?
- [ ] Final treated/control group definition for the small-cap analysis
- [ ] Whether to treat 27 Feb (behavioural) and 15 Mar (disclosure) as separate events in the design
- [ ] Which 2–3 independently verifiable events to use for validating the reconciliation engine

---

## PRE-START CHECKLIST (before 19 Aug)

- [ ] Clear disk space
- [ ] Install native Windows PostgreSQL + pgAdmin
- [ ] Confirm connection via `psql`, create an empty database, stop there
- [ ] Poke at the AMFI NAV endpoint just to see the format — don't build anything
- [ ] Run the Nippon 15-March-2024 stress test retrieval test
- [ ] `git init` the project folder and **write `.gitignore` before the first commit**
      (a raw AMFI dump committed once stays in git history even after deletion)
- [ ] Create the empty GitHub repo and add the remote
- [ ] **Do NOT** install Postgres and start following SQL tutorials in it to "get ready" —
      the ongoing SQL course is enough. Arriving with the event definition nailed down is
      worth far more than practising joins on sample data.
