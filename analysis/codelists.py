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


acute_otitis_media_tx_codelist = codelist_from_csv(
    "codelists/opensafely-pharmacy-first-acute-otitis-media-treatment-full-dmd-codelist.csv",
    column="code",
)

impetigo_treatment_tx_codelist = codelist_from_csv(
    "codelists/opensafely-pharmacy-first-impetigo-treatment-full-dmd-codelist.csv",
    column="code",
)

infected_insect_bites_tx_codelist = codelist_from_csv(
    "codelists/opensafely-pharmacy-first-infected-insect-bites-treatment-full-dmd-codelist.csv",
    column="code",
)

shingles_treatment_tx_codelist = codelist_from_csv(
    "codelists/opensafely-pharmacy-first-shingles-treatment-full-dmd-codelist.csv",
    column="code",
)

sinusitis_tx_codelist = codelist_from_csv(
    "codelists/opensafely-pharmacy-first-sinusitis-treatment-full-dmd-codelist.csv",
    column="code",
)

sore_throat_tx_codelist = codelist_from_csv(
    "codelists/opensafely-pharmacy-first-sore-throat-treatment-full-dmd-codelist.csv",
    column="code",
)

urinary_tract_infection_tx_codelist = codelist_from_csv(
    "codelists/opensafely-pharmacy-first-urinary-tract-infection-treatment-full-dmd-codelist.csv",
    column="code",
)

pf_med_codelist = (
    acute_otitis_media_tx_codelist
    + impetigo_treatment_tx_codelist
    + infected_insect_bites_tx_codelist
    + shingles_treatment_tx_codelist
    + sinusitis_tx_codelist
    + sore_throat_tx_codelist
    + urinary_tract_infection_tx_codelist
)
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
