library(here)
library(tidyverse)

pf_consultations_with_breakdowns <- read_csv(
  here("output", "measures", "pf_breakdown_measures.csv")
)
pf_completeness <- read_csv(
  here("output", "measures", "pf_descriptive_stats_measures.csv")
)

pf_consultations_clean <- pf_consultations_with_breakdowns %>%
  mutate(
    group_type = case_when(
      !is.na(age_band) ~ "Age band",
      !is.na(sex) ~ "Sex",
      !is.na(imd) ~ "IMD",
      !is.na(region) ~ "Region",
      !is.na(ethnicity) ~ "Ethnicity",
      TRUE ~ "Overall"
    ),
    group = coalesce(age_band, sex, imd, region, ethnicity),
    measure_type = case_when(
      str_detect(measure, "consultation|service") ~ "clinical_service",
      TRUE ~ "clinical_condition"
    ),
    measure = str_remove(measure, "^count_") %>%
      str_remove("_by_.*$")
  ) %>%
  transmute(
    measure_type,
    measure,
    interval_start,
    interval_end,
    group_type,
    group,
    count = numerator,
  ) %>%
  arrange(interval_start, measure_type, measure, group_type, group)

pf_completeness_clean <- pf_completeness %>%
  filter(
    measure == "pfmed_with_pfid" |
      measure == "pfcondition_with_pfid" |
      measure == "pfmed_and_pfcondition_with_pfid",
    interval_start >= as.Date("2024-02-01")
  ) %>%
  select(-ratio, -denominator) %>%
  rename(count = numerator)

pf_consultations_only <- pf_consultations_clean %>%
  filter(measure_type == "clinical_service")

pf_conditions_only <- pf_consultations_clean %>%
  filter(
    measure_type == "clinical_condition",
    interval_start >= as.Date("2024-02-01"), 
    group_type == "Overall"
  )

dir.create(here("output", "user_tables"))

readr::write_csv(
  pf_consultations_only,
  here::here("output", "user_tables", "pf_consultations_with_breakdowns.csv")
)

readr::write_csv(
  pf_conditions_only,
  here::here("output", "user_tables", "pf_conditions.csv")
)

readr::write_csv(
  pf_completeness_clean,
  here::here("output", "user_tables", "pf_completeness.csv")
)
