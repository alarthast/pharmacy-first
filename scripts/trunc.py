import argparse
import pathlib
import re
import sys

FINAL_QUERY = re.compile(r"-- Run query (\d+) / (\d+)")
MAX_INSERTS = 5


def is_insert(line):
    return line.lstrip().upper().startswith("INSERT INTO")


def collapse_inserts(lines):
    """Yield lines, collapsing each run of consecutive INSERT INTO lines to
    the first MAX_INSERTS plus an '... omitted' comment."""
    run = 0  # length of the current run of INSERTs
    for line in lines:
        if is_insert(line):
            run += 1
            if run <= MAX_INSERTS:
                yield line
            continue
        if run > MAX_INSERTS:
            yield f"-- ... {run - MAX_INSERTS} further INSERT statements omitted\n"
        run = 0
        yield line


def truncate_sql_file(sql_file, num_queries, intervals=15, omit_inserts=False):
    """Write a copy of sql_file that stops at the start of the query after
    the last one to keep, i.e. at the marker
    '-- Run query (num_queries + 1) / (num_queries * intervals)'.

    If the file already ends at its final query (a line like
    '-- Run query 032 / 032'), there is nothing to cut and the whole file
    is kept.

    If omit_inserts, long runs of INSERT INTO lines are also collapsed and
    the copy is saved as <name>.compact; otherwise as <name>.truncated.
    Returns the output path.
    """
    sql_file = pathlib.Path(sql_file)
    marker = f"-- Run query {num_queries + 1:03d} / {num_queries * intervals:03d}"

    with open(sql_file) as f:
        lines = collapse_inserts(f) if omit_inserts else f
        kept = []
        is_complete = False
        stopped_at = marker
        for line in lines:
            if marker in line:
                break
            if not is_complete and (m := FINAL_QUERY.search(line)):
                is_complete = m[1] == m[2]
            kept.append(line)
        else:
            if not is_complete:
                sys.exit(f"Marker '{marker}' not found in {sql_file}")
            stopped_at = "end of file (final query reached)"

    suffix = ".compact" if omit_inserts else ".truncated"
    out_file = sql_file.with_name(sql_file.name + suffix)
    out_file.write_text("".join(kept))
    print(f"Wrote {out_file} (stopped at {stopped_at})")
    return out_file


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("sql_file")
    parser.add_argument("num_queries", type=int)
    parser.add_argument("--intervals", type=int, default=15)
    parser.add_argument(
        "--omit-inserts",
        action="store_true",
        help="collapse long runs of INSERT INTO lines; writes .sql.compact",
    )
    args = parser.parse_args()
    truncate_sql_file(
        args.sql_file,
        args.num_queries,
        intervals=args.intervals,
        omit_inserts=args.omit_inserts,
    )
