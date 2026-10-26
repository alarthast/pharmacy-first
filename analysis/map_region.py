import argparse
import pathlib

import pandas

MEASURE_NUMERIC_COLUMNS = ["ratio", "numerator", "denominator"]
MISSING_MSOA_CODE = "Missing"

COUNTRY_MAP = {"E": "England", "W": "Wales", "S": "Scotland", "N": "Northern Ireland"}


def read_csv(path):
    data = pandas.read_csv(path, dtype=str)
    for column in MEASURE_NUMERIC_COLUMNS:
        if column in data.columns:
            data[column] = pandas.to_numeric(data[column])
    return data


def map_dataset(src_path, dest_path):
    dataset = read_csv(src_path)

    missing_rows = dataset[dataset["msoa_code"] == MISSING_MSOA_CODE].copy()
    missing_rows["region"] = MISSING_MSOA_CODE

    other_rows = dataset[dataset["msoa_code"] != MISSING_MSOA_CODE].copy()
    # We don't have region, so we replace it by the country for this exercise.
    other_rows["region"] = other_rows["msoa_code"].str[0].map(COUNTRY_MAP)

    dataset = pandas.concat([other_rows, missing_rows])
    dataset.drop(columns=["msoa_code"], inplace=True)
    dataset.to_csv(dest_path, index=False)


def _get_groupby(measure_dataframe):
    columns = [c for c in measure_dataframe.columns if c not in MEASURE_NUMERIC_COLUMNS]
    empty_cols = [c for c in columns if measure_dataframe.loc[:, c].isna().all()]
    groupby = [c for c in columns if c not in empty_cols]
    return groupby, empty_cols


def map_measure(src_path, dest_path):
    measure = read_csv(src_path)
    # Rename the measure
    if "measure" in measure.columns:
        measure["measure"] = measure["measure"].str.replace(
            "_by_msoa_code", "_by_region", regex=False
        )

    non_geographic_rows = measure[measure["msoa_code"].isna()].copy()
    non_geographic_rows.rename(columns={"msoa_code": "region"}, inplace=True)
    # These rows then have the columns in the order the original study outputs do
    column_order = list(non_geographic_rows.columns)

    missing_rows = measure[measure["msoa_code"] == MISSING_MSOA_CODE].copy()
    missing_rows.rename(columns={"msoa_code": "region"}, inplace=True)

    msoa_rows = measure[
        measure["msoa_code"].notna() & (measure["msoa_code"] != MISSING_MSOA_CODE)
    ].copy()
    # We don't have region, so we replace it by the country for this exercise.
    msoa_rows["region"] = msoa_rows["msoa_code"].str[0].map(COUNTRY_MAP)
    msoa_rows.drop(columns=["msoa_code"], inplace=True)
    groupby, empty_cols = _get_groupby(msoa_rows)
    msoa_rows.drop(columns=empty_cols, inplace=True)
    region_rows = msoa_rows.groupby(groupby).sum().reset_index()
    region_rows["ratio"] = region_rows["numerator"] / region_rows["denominator"]
    for col in empty_cols:
        region_rows[col] = None
    measure = pandas.concat([region_rows, missing_rows, non_geographic_rows])
    measure.loc[:, column_order].to_csv(dest_path, index=False)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Map MSOA codes to regions")
    parser.add_argument(
        "--file-type",
        type=str,
        help="File type (dataset or measure)",
        choices=["dataset", "measure"],
        required=True,
    )
    parser.add_argument(
        "--src-path", type=str, help="Path to the file to map", required=True
    )
    parser.add_argument(
        "--dest-path", type=str, help="Path to save the mapped file", required=True
    )
    args = parser.parse_args()

    pathlib.Path(args.dest_path).parent.mkdir(parents=True, exist_ok=True)

    if args.file_type == "dataset":
        map_dataset(args.src_path, args.dest_path)
    elif args.file_type == "measure":
        map_measure(args.src_path, args.dest_path)
