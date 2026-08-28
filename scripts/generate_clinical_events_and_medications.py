import collections
import csv
import datetime
import json

from analysis import codelists, config

NON_PF_SNOMEDCT_CODE = "123456789"
NON_PF_DMD_CODE = "12354611500001104"
ETHNICITY_CODES = list(codelists.ethnicity_group16_codelist.keys())


def load_codelist_by_condition_json():
    with open("scripts/codelists_by_condition.json", "r") as f:
        return json.load(f)


CODELISTS_BY_CONDITION = load_codelist_by_condition_json()

CONSULTATION_SNOMED_CODES = codelists.pf_consultation_events_dict[
    "pf_consultation_services_combined"
]
CONDITION_SNOMED_CODES = list(codelists.pf_conditions_codelist.keys())
MEDICATION_DMD_CODES = sorted(
    {code for cond in CODELISTS_BY_CONDITION.values() for code in cond["dmd_codes"]}
)

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


def get_ethnicity_events(patient_ids):
    return [
        ClinicalEventsRow(
            patient_id,
            None,
            EVENTS_START_DATE,
            ETHNICITY_CODES[i % len(ETHNICITY_CODES)],
        )
        for i, patient_id in enumerate(patient_ids)
        if int(patient_id) % 100 != 0  # Have missing ethnicity for some patients
    ]


def _get_pf_consultation_snomedct_code(consultation_id):
    codes = codelists.pf_consultation_events_dict["pf_consultation_services_combined"]
    assert len(codes) == 3
    return codes[consultation_id % 3]


def _get_pf_condition_term(patient_id):
    keys = list(CODELISTS_BY_CONDITION.keys())
    assert len(keys) == 7
    return keys[int(patient_id) % 7]


def _get_pf_condition_snomedct_code(patient_id):
    term = _get_pf_condition_term(patient_id)
    return CODELISTS_BY_CONDITION[term]["snomed_code"]


def _get_pf_med_dmd_code(patient_id, consultation_id):
    term = _get_pf_condition_term(patient_id)
    codelist = CODELISTS_BY_CONDITION[term]["dmd_codes"]
    return codelist[int(consultation_id) % len(codelist)]


def _build(
    patient_id,
    consultation_id,
    consultation_date,
    *,
    consultation_code,
    condition_code,
    med_code,
):
    events = []
    events.append(
        ClinicalEventsRow(
            patient_id, consultation_id, consultation_date, consultation_code
        )
    )
    events.append(
        ClinicalEventsRow(
            patient_id, consultation_id, consultation_date, condition_code
        )
    )
    return {
        "clinical_events": events,
        "medications": [
            MedicationsRow(patient_id, consultation_id, consultation_date, med_code)
        ],
    }


def get_pf_both(patient_id, consultation_id, consultation_date):
    return _build(
        patient_id,
        consultation_id,
        consultation_date,
        consultation_code=_get_pf_consultation_snomedct_code(consultation_id),
        condition_code=_get_pf_condition_snomedct_code(consultation_id),
        med_code=_get_pf_med_dmd_code(patient_id, consultation_id),
    )


def get_pf_condition_only(patient_id, consultation_id, consultation_date):
    return _build(
        patient_id,
        consultation_id,
        consultation_date,
        consultation_code=_get_pf_consultation_snomedct_code(consultation_id),
        condition_code=_get_pf_condition_snomedct_code(consultation_id),
        med_code=NON_PF_DMD_CODE,
    )


def get_pf_med_only(patient_id, consultation_id, consultation_date):
    return _build(
        patient_id,
        consultation_id,
        consultation_date,
        consultation_code=_get_pf_consultation_snomedct_code(consultation_id),
        condition_code=NON_PF_SNOMEDCT_CODE,
        med_code=_get_pf_med_dmd_code(patient_id, consultation_id),
    )


def get_pf_neither(patient_id, consultation_id, consultation_date):
    return _build(
        patient_id,
        consultation_id,
        consultation_date,
        consultation_code=_get_pf_consultation_snomedct_code(consultation_id),
        condition_code=NON_PF_SNOMEDCT_CODE,
        med_code=NON_PF_DMD_CODE,
    )


def fill_rows(patient_ids, clinical_events, medications):
    getters = [
        get_pf_both,
        get_pf_both,
        get_pf_both,
        get_pf_both,
        get_pf_condition_only,
        get_pf_condition_only,
        get_pf_condition_only,
        get_pf_med_only,
        get_pf_neither,
    ]

    consultation_ids = iter(range(999999))

    num_consultations_per_patient = [i % 9 + 1 for i in range(len(patient_ids))]

    for loop_number in range(9):
        for i, patient_id in enumerate(patient_ids):
            if loop_number >= num_consultations_per_patient[i]:
                continue
            consultation_id = next(consultation_ids)
            consultation_date = EVENTS_START_DATE + datetime.timedelta(
                days=consultation_id % NUM_POSSIBLE_DAYS
            )
            getter = getters[consultation_id % len(getters)]
            generated = getter(patient_id, consultation_id, consultation_date)
            clinical_events.extend(generated["clinical_events"])
            medications.extend(generated["medications"])


def write_csv(filepath, rows):
    if not rows:
        return
    with open(filepath, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(rows[0]._fields)
        writer.writerows(rows)


def main():
    patient_ids = get_patient_ids("dummy_tables/patients.csv")
    clinical_events = get_ethnicity_events(patient_ids)
    medications = []
    fill_rows(patient_ids, clinical_events, medications)
    write_csv("dummy_tables/clinical_events.csv", clinical_events)
    write_csv("dummy_tables/medications.csv", medications)


main()
