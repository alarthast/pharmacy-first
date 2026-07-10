import csv


def drop_rows_with_same_grouping_16_and_grouping_6(rows):
    seen = set()
    for row in rows:
        combination = (row[2], row[3])
        if combination not in seen:
            seen.add(combination)
            yield row


def get_rows():
    with open(
        "codelists/opensafely-ethnicity-snomed-0removed_original.csv", "r", newline=""
    ) as f:
        return list(csv.reader(f))


def main():
    rows = get_rows()
    minimal_rows = [rows[0]] + list(
        drop_rows_with_same_grouping_16_and_grouping_6(rows[1:])
    )

    with open(
        "codelists/opensafely-ethnicity-snomed-0removed.csv", "w", newline=""
    ) as new_file:
        writer = csv.writer(new_file)
        writer.writerows(minimal_rows)


if __name__ == "__main__":
    main()
