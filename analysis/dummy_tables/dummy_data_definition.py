from ehrql import create_dataset
from ehrql.tables.emisv2 import (
    addresses,
    patients,
    practice_registrations,
)

from analysis import config

DUMMY_DATA_START_DATE, DUMMY_DATA_END_DATE = config.get_dummy_data_date_range()

dataset = create_dataset()
dataset.configure_dummy_data(population_size=5000)


registration = practice_registrations.for_patient_on(DUMMY_DATA_START_DATE)
address = addresses.for_patient_on(DUMMY_DATA_START_DATE)

dataset.imd_rounded = address.imd_rounded
dataset.msoa_code = address.msoa_code
dataset.date_of_birth = patients.date_of_birth

dataset.define_population(
    registration.exists_for_patient()
    & address.exists_for_patient()
    & patients.sex.is_in(["male", "female"])
    & patients.date_of_birth.is_not_null()
)
