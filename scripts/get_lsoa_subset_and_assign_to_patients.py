import json
import pathlib
import csv
import pandas as pd
import numpy as np

MEASURE_NUMERIC_COLUMNS = ["ratio", "numerator", "denominator"]


def get_msoa_to_region_mapping():
    # https://geoportal.statistics.gov.uk/datasets/ons::msoa-2021-to-bua-to-lad-to-region-december-2022-best-fit-lookup-in-ew-v2/about
    mapping_file = (
        pathlib.Path(__file__).parents[1]
        / "ONS-data"
        / "MSOA_(2021)_to_Built-up_Area_to_Local_Authority_District_to_Region_(December_2022)_Lookup_in_England_and_Wales_v2.geojson"
    )
    with open(mapping_file) as f:
        geojson = json.load(f)
    return {
        feature["properties"]["MSOA21CD"]: feature["properties"]["RGN22NM"]
        for feature in geojson["features"]
    }


def get_lsoa_to_msoa_mapping():
    mapping_file = (
        pathlib.Path(__file__).parents[1]
        / "ONS-data"
        / "OA21_LAD22_LSOA21_MSOA21_LEP22_EN_LU_V2_5939234815342952606.csv"
    )
    df = pd.read_csv(mapping_file, usecols=["LSOA21CD", "MSOA21CD"]).drop_duplicates()
    return dict(zip(df["LSOA21CD"], df["MSOA21CD"]))


def get_lsoa_to_name_mapping():
    mapping_file = (
        pathlib.Path(__file__).parents[1]
        / "ONS-data"
        / "OA21_LAD22_LSOA21_MSOA21_LEP22_EN_LU_V2_5939234815342952606.csv"
    )
    df = pd.read_csv(mapping_file, usecols=["LSOA21CD", "LSOA21NM"]).drop_duplicates()
    return dict(zip(df["LSOA21CD"], df["LSOA21NM"]))


def get_lsoa_to_imd_mapping():
    mapping_file = (
        pathlib.Path(__file__).parents[1]
        / "ONS-data"
        / "File_1_IoD2025_Index_of_Multiple_Deprivation - IMD25.csv"
    )
    mapping = {}
    with open(mapping_file, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            decile = int(
                row[
                    "Index of Multiple Deprivation (IMD) Decile (where 1 is most deprived 10% of LSOA"
                ]
            )
            rank = int(
                row[
                    "Index of Multiple Deprivation (IMD) Rank (where 1 is most deprived)"
                ]
            )
            mapping[row["LSOA code (2021)"]] = {
                "quintile": (decile + 1) // 2,
                "rank": rank,
            }
    return mapping


def build_lsoa_region_imd_table():
    lsoa_to_msoa = get_lsoa_to_msoa_mapping()
    msoa_to_region = get_msoa_to_region_mapping()
    lsoa_to_imd = get_lsoa_to_imd_mapping()
    lsoa_to_name = get_lsoa_to_name_mapping()

    rows = []
    seen_combos = set()
    seen_names = set()
    for lsoa, msoa in lsoa_to_msoa.items():
        region = msoa_to_region.get(msoa)
        imd = lsoa_to_imd.get(lsoa, {})
        imd_quintile = imd.get("quintile")
        imd_rank = imd.get("rank")
        name = lsoa_to_name.get(lsoa)
        name_prefix = name.rsplit(" ", 1)[0] if name else name

        if name_prefix in seen_names:
            continue

        combo_key = (region, imd_quintile)
        if combo_key in seen_combos:
            continue

        seen_combos.add(combo_key)
        seen_names.add(name_prefix)

        rows.append(
            {
                "LSOA": lsoa,
                "LSOA21NM": name,
                "MSOA": msoa,
                "Region": region,
                "IMD_quintile": imd_quintile,
                "imd_rounded": round(imd_rank / 100) * 100,
            }
        )

    return pd.DataFrame(
        rows,
        columns=["LSOA", "LSOA21NM", "MSOA", "Region", "IMD_quintile", "imd_rounded"],
    )


def main():
    addresses_file = (
        pathlib.Path(__file__).parents[1] / "dummy_tables" / "addresses.csv"
    )

    lsoa_choices = build_lsoa_region_imd_table()

    addresses = pd.read_csv(addresses_file)
    n = len(addresses)

    indices = np.arange(n) % len(lsoa_choices)
    picked = lsoa_choices.iloc[indices]

    addresses["msoa_code"] = picked["MSOA"].to_numpy()
    addresses["imd_rounded"] = picked["imd_rounded"].to_numpy()

    # blank out every 20th row)
    missing_mask = (np.arange(n) % 20) == 0
    addresses.loc[missing_mask, "msoa_code"] = np.nan
    addresses.loc[missing_mask, "imd_rounded"] = np.nan

    lsoa_choices.to_csv("lsoa_choices.csv", index=False)
    addresses.to_csv(addresses_file, index=False)
    return addresses


main()


main()
