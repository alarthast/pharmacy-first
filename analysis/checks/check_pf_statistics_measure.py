# Written by Claude as a sanity check

import csv


def main():
    path = "output/measures/pf_descriptive_stats_measures.csv"
    with open(path, newline="") as f:
        reader = csv.DictReader(f)
        for i, row in enumerate(reader, start=2):
            measure = row["measure"]
            denom = float(row["denominator"])
            numer = float(row["numerator"])
            ratio = float(row["ratio"])
            if denom <= 0:
                raise ValueError(
                    f"line {i}: {measure} has non-positive denominator ({denom})"
                )
            if measure == "pfconsultations_with_pfid_count" and ratio < 1:
                raise ValueError(
                    f"line {i}: {measure} ratio {ratio} < 1 (num={numer}, denom={denom})"
                )

    print("All checks passed")


if __name__ == "__main__":
    main()
