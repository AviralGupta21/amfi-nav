"""
convert_stress_test.py
Converts AMFI's monthly small cap stress test disclosures from xlsx to CSV
for loading into staging.stress_test_raw.

The source files carry a three-row merged header (rows 3-5) plus a title
block (rows 1-2) and a blank row, so data begins at row 7. Rows 1-6 are
skipped and the header is supplied at load time instead.

The portfolio date is derived from the FILENAME, not from the file's own
date column. That column reads 01-Feb-2024, 01-Mar-2024 and so on - a month
label rather than an as-of date. The disclosures are published by the 15th
based on the preceding month's data, and the AUM series matches month-end
figures reported elsewhere, so month-end is the true reference date.
Recorded in core.stress_test as as_of_source = 'file_name'.
"""

import calendar
import glob
import os
import re
from datetime import date

import pandas as pd

SRC_DIR = "data/stress_test"
PATTERN = "risk-parameters-small-cap-*.xlsx"
SKIP_ROWS = 6
EXPECTED_COLS = 18

MONTHS = {m: i for i, m in enumerate(calendar.month_name) if m}


def month_end_from_filename(filename):
    """risk-parameters-small-cap-February_2024.xlsx -> date(2024, 2, 29)"""
    match = re.search(r"-([A-Za-z]+)[ _](\d{4})\.xlsx$", filename)
    if not match:
        raise ValueError("cannot parse month and year from %s" % filename)
    month_name, year = match.group(1), int(match.group(2))
    if month_name not in MONTHS:
        raise ValueError("unrecognised month %r in %s" % (month_name, filename))
    month = MONTHS[month_name]
    last_day = calendar.monthrange(year, month)[1]
    return date(year, month, last_day)


def convert(path):
    filename = os.path.basename(path)
    as_of = month_end_from_filename(filename)

    df = pd.read_excel(path, header=None, skiprows=SKIP_ROWS)

    if df.shape[1] != EXPECTED_COLS:
        raise ValueError(
            "%s has %d columns, expected %d" % (filename, df.shape[1], EXPECTED_COLS)
        )

    # column 1 is Scheme Name; drop trailing blank rows
    df = df[df[1].notna()].copy()

    df["source_file"] = filename
    df["as_of_month"] = as_of.isoformat()

    out_path = os.path.join(
        SRC_DIR, "stress_test_%s.csv" % as_of.strftime("%Y_%m")
    )
    df.to_csv(out_path, index=False, header=False)

    print("%-52s -> %-28s %3d rows  as_of %s"
          % (filename, os.path.basename(out_path), len(df), as_of))
    return len(df)


def main():
    paths = sorted(glob.glob(os.path.join(SRC_DIR, PATTERN)))
    if not paths:
        raise SystemExit("no files matching %s in %s" % (PATTERN, SRC_DIR))

    total = sum(convert(p) for p in paths)
    print("\n%d files, %d rows total" % (len(paths), total))


if __name__ == "__main__":
    main()