import pathlib

import numpy as np
import pandas as pd

from scripts.get_lsoa_subset_and_assign_to_patients import build_lsoa_region_imd_table

addresses_file = pathlib.Path(__file__).parents[1] / "dummy_tables" / "addresses.csv"
addresses = pd.read_csv(addresses_file, dtype=str)

print("=== addresses.csv: msoa_code value counts (top 20) ===")
print(addresses["msoa_code"].value_counts().head(20))
print()

print("=== addresses.csv: imd_rounded distribution ===")
print(addresses["imd_rounded"].value_counts(dropna=False))
print()

# Cross-check against lsoa_choices directly, since addresses is built
# by cycling through lsoa_choices via `indices = np.arange(n) % len(lsoa_choices)`
lsoa_choices = build_lsoa_region_imd_table()

print(f"len(lsoa_choices) = {len(lsoa_choices)}")
print()

print("=== lsoa_choices: rows per Region ===")
print(lsoa_choices["Region"].value_counts(dropna=False))
print()

print("=== lsoa_choices: rows per IMD quintile (derived from IMD_rank) ===")
print(lsoa_choices["IMD_quintile"].value_counts(dropna=False).sort_index())
# recreate quintile the same way the IMD breakdown does, for comparison
max_imd = 33_755
conditions = [
    (lsoa_choices["imd_rounded"] >= 0)
    & (lsoa_choices["imd_rounded"] < int(max_imd * 1 / 5)),
    lsoa_choices["imd_rounded"] < int(max_imd * 2 / 5),
    lsoa_choices["imd_rounded"] < int(max_imd * 3 / 5),
    lsoa_choices["imd_rounded"] < int(max_imd * 4 / 5),
    lsoa_choices["imd_rounded"] <= max_imd,
]
choices = ["1 (Most Deprived)", "2", "3", "4", "5 (Least Deprived)"]
lsoa_choices["quintile_check"] = np.select(conditions, choices, default="Missing")
print(lsoa_choices["quintile_check"].value_counts(dropna=False).sort_index())
