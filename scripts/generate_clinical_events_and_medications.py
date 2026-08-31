import collections
import csv
import datetime
import json
import random

from analysis import codelists, config

# For convenience
random.seed("123456789")

NON_PF_SNOMEDCT_CODE = "123456789"
NON_PF_DMD_CODE = "12354611500001104"


def load_codelist_by_condition_json():
    with open("scripts/codelists_by_condition.json", "r") as f:
        return json.load(f)


ETHNICITY_CODES = list(codelists.ethnicity_group16_codelist.keys()) + [
    NON_PF_SNOMEDCT_CODE
]
CODELISTS_BY_CONDITION = load_codelist_by_condition_json()

CONSULTATION_SNOMED_CODES = codelists.pf_consultation_events_dict[
    "pf_consultation_services_combined"
]
CONDITION_SNOMED_CODES = list(codelists.pf_conditions_codelist.keys()) + [
    NON_PF_SNOMEDCT_CODE,
    "234567890",
]
MEDICATION_DMD_CODES = sorted(
    {code for cond in CODELISTS_BY_CONDITION.values() for code in cond["dmd_codes"]}
) + [NON_PF_DMD_CODE]

# Dump codelists.json from this file so that it stays in sync with the dummy data
with open("codelists.json", "w") as f:
    json.dump(
        {
            name: codes
            for name, codes in [
                ("ETHNICITY_CODES", ETHNICITY_CODES),
                ("CONSULTATION_SNOMED_CODES", CONSULTATION_SNOMED_CODES),
                ("CONDITION_SNOMED_CODES", CONDITION_SNOMED_CODES),
                ("MEDICATION_DMD_CODES", MEDICATION_DMD_CODES),
            ]
        },
        f,
        indent=2,
    )

EVENTS_START_DATE, EVENTS_END_DATE = config.get_dummy_data_date_range()
NUM_POSSIBLE_DAYS = (EVENTS_END_DATE - EVENTS_START_DATE).days
# Our spec will ask for 2023-11-01 to 2025-01-31 inclusive
assert EVENTS_START_DATE == datetime.date(2023, 11, 1), EVENTS_START_DATE
assert EVENTS_END_DATE == datetime.date(2025, 2, 1)

ClinicalEventsRow = collections.namedtuple(
    "ClinicalEventsRow", ["patient_id", "consultation_id", "date", "snomedct_code"]
)
MedicationsRow = collections.namedtuple(
    "MedicationsRow", ["patient_id", "consultation_id", "date", "dmd_code"]
)


def get_patient_ids(csv_filepath):
    with open(csv_filepath, newline="") as f:
        reader = csv.DictReader(f)
        return [row["patient_id"] for row in reader]


def generate_consultation_rows(patient_ids):
    clinical_events = []
    medications = []
    for patient_id in patient_ids[:100]:
        num_consultations = random.randint(1, 10)
        for loop_number in range(num_consultations):
            consultation_id = f"{patient_id}-{loop_number}"
            consultation_date = EVENTS_START_DATE + datetime.timedelta(
                days=random.randint(0, NUM_POSSIBLE_DAYS - 1)
            )
            clinical_events.append(
                ClinicalEventsRow(
                    patient_id,
                    consultation_id,
                    consultation_date,
                    random.choice(CONSULTATION_SNOMED_CODES),
                )
            )
            clinical_events.append(
                ClinicalEventsRow(
                    patient_id,
                    consultation_id,
                    consultation_date,
                    random.choice(CONDITION_SNOMED_CODES),
                )
            )
            medications.append(
                MedicationsRow(
                    patient_id,
                    consultation_id,
                    consultation_date,
                    random.choice(MEDICATION_DMD_CODES),
                )
            )
    return clinical_events, medications


def write_csv(filepath, rows):
    if not rows:
        return
    with open(filepath, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(rows[0]._fields)
        writer.writerows(rows)


def main():
    patient_ids = get_patient_ids("dummy_tables/patients.csv")
    clinical_events = [
        ClinicalEventsRow(
            patient_id, None, EVENTS_START_DATE, random.choice(ETHNICITY_CODES)
        )
        for patient_id in patient_ids
    ]
    consultation_clinical_events, medications = generate_consultation_rows(patient_ids)
    clinical_events.extend(consultation_clinical_events)
    write_csv("dummy_tables/clinical_events.csv", clinical_events)
    write_csv("dummy_tables/medications.csv", medications)


main()
