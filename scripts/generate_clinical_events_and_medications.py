import collections
from analysis import codelists, config
import datetime
import csv


NON_PF_SNOMEDCT_CODE = "123456789"
NON_PF_DMD_CODE = "12354611500001104"
ETHNICITY_CODES = list(codelists.ethnicity_group16_codelist.keys())

ClinicalEventsRow = collections.namedtuple(
    "ClinicalEventsRow", ["patient_id", "consultation_id", "date", "snomedct_code"]
)
MedicationsRow = collections.namedtuple(
    "ClinicalEventsRow", ["patient_id", "consultation_id", "date", "dmd_code"]
)


def get_patient_ids(csv_filepath):
    with open(csv_filepath, newline="") as f:
        reader = csv.DictReader(f)
        return [row["patient_id"] for row in reader]


def get_ethnicity_events(patient_ids):
    date, _ = config.get_dummy_data_date_range()
    return [
        ClinicalEventsRow(
            patient_id, None, date, ETHNICITY_CODES[i % len(ETHNICITY_CODES)]
        )
        for i, patient_id in enumerate(patient_ids)
        if int(patient_id) % 100 != 0  # Have missing ethnicity for some patients
    ]


def _get_pf_consultation_snomedct_code(consultation_id):
    codes = codelists.pf_consultation_events_dict["pf_consultation_services_combined"]
    assert len(codes) == 3
    return codes[consultation_id % 3]


def _get_pf_condition_snomedct_code(patient_id):
    codes = list(codelists.pf_conditions_codelist.keys())
    assert len(codes) == 7
    return codes[int(patient_id) % 7]


def _get_pf_med_dmd_code():
    # for now just use one code
    return codelists.pf_med_codelist[0]


def _build(
    patient_id,
    consultation_id,
    consultation_date,
    *,
    consultation_code,
    condition_code,
    med_code,
):
    # Shared row assembly for every getter below. `consultation_code=None` omits
    # the consultation clinical event entirely (the non-PF-consultation-linked case).
    events = []
    if consultation_code is not None:
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
        med_code=_get_pf_med_dmd_code(),
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
        med_code=_get_pf_med_dmd_code(),
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
    events_start_date, events_end_date = config.get_dummy_data_date_range()
    num_possible_days = (events_end_date - events_start_date).days

    num_consultations_per_patient = [i % 9 + 1 for i in range(len(patient_ids))]

    for loop_number in range(9):
        for i, patient_id in enumerate(patient_ids):
            if loop_number >= num_consultations_per_patient[i]:
                continue
            consultation_id = next(consultation_ids)
            consultation_date = events_start_date + datetime.timedelta(
                days=consultation_id % num_possible_days
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
