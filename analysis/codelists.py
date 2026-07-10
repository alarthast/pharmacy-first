from ehrql import codelist_from_csv

# Import pharmacy first conditions codelist
pf_conditions_codelist = codelist_from_csv(
    "codelists/user-chriswood-pharmacy-first-clinical-pathway-conditions.csv",
    column="code",
    category_column="term",
)

# Import ethnicity codelist
ethnicity_group6_codelist = codelist_from_csv(
    "codelists/opensafely-ethnicity-snomed-0removed.csv",
    column="snomedcode",
    category_column="Grouping_6",
)

# Import ethnicity codelist
ethnicity_group16_codelist = codelist_from_csv(
    "codelists/opensafely-ethnicity-snomed-0removed.csv",
    column="snomedcode",
    category_column="Grouping_16",
)


# Pretend this codelist only contains one code
# TODO: Revert this to a full codelist
pf_med_codelist = ["22706111000001100"]

# Community Pharmacist Consultation Service for minor illness - 1577041000000109
pf_consultation_cp_minorillness = ["1577041000000109"]
# Pharmacy First service - 983341000000102
pf_consultation_service = ["983341000000102"]
# Community Pharmacy First Service - 2129921000000100
pf_consultation_cp_service = ["2129921000000100"]

pf_consultation_events_dict = {
    # Community Pharmacist (CP) Consultation Service for minor illness (procedure)
    "pf_consultation_cp_minorillness": pf_consultation_cp_minorillness,
    # Pharmacy First service (qualifier value)
    "pf_consultation_service": pf_consultation_service,
    # Community Pharmacy Pharmacy First Service
    "pf_consultation_cp_service": pf_consultation_cp_service,
    "pf_consultation_services_combined": pf_consultation_cp_minorillness
    + pf_consultation_service
    + pf_consultation_cp_service,
}

pf_conditions_by_term = {v: k for k, v in pf_conditions_codelist.items()}
uti_code = [pf_conditions_by_term["Uncomplicated urinary tract infection"]]
sinusitis_code = [pf_conditions_by_term["Acute sinusitis"]]
insectbite_code = [pf_conditions_by_term["Infected insect bite"]]
otitismedia_code = [pf_conditions_by_term["Acute otitis media"]]
sorethroat_code = [pf_conditions_by_term["Acute pharyngitis"]]
shingles_code = [pf_conditions_by_term["Herpes zoster"]]
impetigo_code = [pf_conditions_by_term["Impetigo"]]
