import collections
import csv
import json
from pathlib import Path

from analysis import codelists

CODELISTS = {
    "Acute otitis media": codelists.acute_otitis_media_tx_codelist,
    "Acute pharyngitis": codelists.sore_throat_tx_codelist,
    "Acute sinusitis": codelists.sinusitis_tx_codelist,
    "Herpes zoster": codelists.shingles_treatment_tx_codelist,
    "Impetigo": codelists.impetigo_treatment_tx_codelist,
    "Infected insect bite": codelists.infected_insect_bites_tx_codelist,
    "Uncomplicated urinary tract infection": codelists.urinary_tract_infection_tx_codelist,
}

REFERENCE_DIR = Path("lib/reference")
VMP_LOOKUP_CSV = REFERENCE_DIR / "vmp_vtm_lookup.csv"


def load_vmp_lookup(filepath):
    """code -> vmp_nm, for codes that have an entry in the lookup."""
    with open(filepath, newline="") as f:
        reader = csv.DictReader(f)
        return {row["id"]: row["vmp_nm"] for row in reader}


def build_code_to_codelists():
    """
    code -> [codelist names containing it]. The length of this list is used
    as a reuse-preference score (prioritise codes shared across more
    codelists, to minimise the total number of distinct codes selected).
    """
    code_to_codelists = collections.defaultdict(list)
    for codelist_name, codes in CODELISTS.items():
        for code in codes:
            code_to_codelists[code].append(codelist_name)

    return dict(
        sorted(code_to_codelists.items(), key=lambda kv: len(kv[1]), reverse=True)
    )


VMP_LOOKUP = load_vmp_lookup(REFERENCE_DIR / "vmp_vtm_lookup.csv")
CODE_TO_CODELISTS = build_code_to_codelists()

SAME_NAME = "same_name"
OWN_NAME = "maps_to_own_name"
NOT_IN_LOOKUP = "not_in_lookup"


def _reuse_count(code):
    return len(CODE_TO_CODELISTS.get(code, []))


def _group_codes_by_vmp_nm(codes):
    """vmp_nm -> [codes in this codelist with that name] (codes in lookup only)."""
    groups = collections.defaultdict(list)
    for code in codes:
        vmp_nm = VMP_LOOKUP.get(code)
        if vmp_nm is not None:
            groups[vmp_nm].append(code)
    return groups


def _get_same_name_pair(codes):
    """2 codes (within this codelist) sharing a vmp_nm - merge path. [] if none."""
    groups = _group_codes_by_vmp_nm(codes)
    candidates = {name: cds for name, cds in groups.items() if len(cds) >= 2}
    if not candidates:
        return []
    best_name = max(
        candidates, key=lambda n: sum(_reuse_count(c) for c in candidates[n][:2])
    )
    return sorted(candidates[best_name], key=_reuse_count, reverse=True)[:2]


def _get_own_name_code(codes, exclude):
    """1 code (within this codelist) whose vmp_nm isn't shared by any other
    code in this codelist - ordinary path. None if no such code exists."""
    groups = _group_codes_by_vmp_nm(codes)
    candidates = [
        c
        for c in codes
        if c not in exclude and c in VMP_LOOKUP and len(groups[VMP_LOOKUP[c]]) == 1
    ]
    if not candidates:
        return None
    return sorted(candidates, key=_reuse_count, reverse=True)[0]  # noqa: FURB192


def get_minimal_pf_med_codelist():
    selected = {
        codelist_name: {SAME_NAME: [], OWN_NAME: []} for codelist_name in CODELISTS
    }

    # Step 1: per codelist, 3 codes (SAME_NAME pair + OWN_NAME code)
    for codelist_name, codes in CODELISTS.items():
        codes = list(codes)

        pair = _get_same_name_pair(codes)
        if pair:
            selected[codelist_name][SAME_NAME] = pair
        else:
            print(f"WARNING: '{codelist_name}' has no vmp_nm shared by 2+ codes.")

        own_name_code = _get_own_name_code(codes, exclude=pair)
        if own_name_code:
            selected[codelist_name][OWN_NAME] = [own_name_code]
        else:
            print(f"WARNING: '{codelist_name}' has no code with a vmp_nm unique to it.")

    # Step 2: one global not-in-lookup code (only need one across the whole
    # pf_med_codelist), added to whichever codelist(s) contain it.
    missing_from_lookup = [c for c in CODE_TO_CODELISTS if c not in VMP_LOOKUP]
    not_in_lookup_code = None
    if missing_from_lookup:
        not_in_lookup_code = sorted(  # noqa: FURB192
            missing_from_lookup, key=_reuse_count, reverse=True
        )[0]
    else:
        print("WARNING: no code across all codelists is missing from vmp_lookup.")

    # Construct codelists from selected codes
    final = {codelist_name: set() for codelist_name in CODELISTS}
    for codelist_name, categories in selected.items():
        final[codelist_name].update(categories[SAME_NAME])
        final[codelist_name].update(categories[OWN_NAME])
        if (
            not_in_lookup_code
            and codelist_name in CODE_TO_CODELISTS[not_in_lookup_code]
        ):
            final[codelist_name].add(not_in_lookup_code)

    # Step 3: per codelist, top up with a code unique to it (not shared with
    # any other codelist) if reuse-prioritisation didn't already select one.
    for codelist_name, codes in CODELISTS.items():
        if any(_reuse_count(c) == 1 for c in final[codelist_name]):
            continue  # already have one

        unique_candidates = [
            c for c in codes if _reuse_count(c) == 1 and c not in final[codelist_name]
        ]
        if unique_candidates:
            final[codelist_name].add(unique_candidates[0])
        else:
            print(
                f"WARNING: '{codelist_name}' has no code unique to it - skipping top-up."
            )

    pf_med_codelist = set()
    for codelist_name, codes in final.items():
        pf_med_codelist.update(codes)

    pf_med_codelist = sorted(
        pf_med_codelist,
        key=lambda code: (
            -len(CODE_TO_CODELISTS.get(code, [])),
            min(CODE_TO_CODELISTS.get(code, [""])),
            VMP_LOOKUP.get(code, ""),
            code,
        ),
    )
    return pf_med_codelist


def write_med_summary_csv(pf_med_codes):
    with open("scripts/minimised_pf_med_codelist_summary.csv", "w", newline="") as f:
        writer = csv.writer(f)
        header = ["code", "vmp_nm"] + list(CODELISTS.keys())
        writer.writerow(header)

        for code in pf_med_codes:
            vmp_nm = VMP_LOOKUP.get(code, "")
            row = [code, vmp_nm]
            for codelist_name in CODELISTS:  # noqa: PLC0206
                row.append("T" if code in CODELISTS[codelist_name] else "F")
            writer.writerow(row)


def write_med_and_observation_combined_json(all_selected_codes):
    output = {}
    for codelist_name, codelist_codes in CODELISTS.items():
        output[codelist_name] = {
            "dmd_codes": [
                code for code in all_selected_codes if code in codelist_codes
            ],
            "snomed_code": codelists.pf_conditions_by_term[codelist_name],
        }

    with open("scripts/codelists_by_condition.json", "w") as f:
        json.dump(output, f, indent=2)


def main():
    med_codelist = get_minimal_pf_med_codelist()
    write_med_summary_csv(med_codelist)
    write_med_and_observation_combined_json(med_codelist)


main()
