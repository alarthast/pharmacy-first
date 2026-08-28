import csv


def main():
    path = "output/measures/pf_breakdown_measures_msoa.csv"
    found_nonzero = 0
    total_by_region = 0

    with open(path, newline="") as f:
        reader = csv.DictReader(f)
        for i, row in enumerate(reader, start=2):
            measure = row["measure"]
            if "_by_region" not in measure:
                continue

            total_by_region += 1

            try:
                denom = float(row["denominator"]) if row["denominator"] != "" else 0.0
                numer = float(row["numerator"]) if row["numerator"] != "" else 0.0
            except ValueError:
                denom = 0.0
                numer = 0.0

            if denom > 0 or numer > 0:
                found_nonzero += 1
                print(
                    f"line {i}: {measure} numerator={numer} denominator={denom} "
                    f"region={row.get('region', '')}"
                )

    print(f"\nChecked {total_by_region} by_region rows")
    print(f"Found {found_nonzero} rows with non-zero numerator or denominator")

    if found_nonzero == 0:
        print("ALL by_region rows are zero — data is fully suppressed/missing")


if __name__ == "__main__":
    main()
