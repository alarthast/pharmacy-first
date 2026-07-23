import datetime
from dateutil.relativedelta import relativedelta

# Dataset definition: dataset_definition_tables.py
# Timeframe: 31/01/2024 - 31/01/2025
start_date_dataset_tables = "2024-01-31"
index_date_dataset_tables = "2025-01-31"

# Measure: measures_definition_pf_condition_provider.py
# Timeframe: 01/01/2023 - 31/01/2025
start_date_measure_condition_provider = "2023-01-01"
monthly_intervals_measure_condition_provider = 25

# Number of months included in the monthly dashboard - INCREASE THIS INTERVAL BY ONE EACH MONTH
# Current timeframe of monthly dashboard: 01/11/2023 - 31/05/2026 (UPDATE this timeframe monthly)
monthly_dashboard_intervals = 31

# Measure: measures_definition_pf_breakdown.py
start_date_measure_pf_breakdown = "2023-11-01"
monthly_intervals_measure_pf_breakdown = monthly_dashboard_intervals

# Measure: measures_definition_pf_descriptive_stats.py
start_date_measure_descriptive_stats = "2023-11-01"
monthly_intervals_measure_descriptive_stats = monthly_dashboard_intervals

# Measure: measures_definition_pf_consultation_pf_counts.py
start_date_measure_med_counts = "2023-11-01"
monthly_intervals_measure_med_counts = monthly_dashboard_intervals


def get_dummy_data_date_range():
    start = min(
        datetime.datetime.strptime(start_date_dataset_tables, "%Y-%m-%d"),
        datetime.datetime.strptime(start_date_measure_condition_provider, "%Y-%m-%d"),
        datetime.datetime.strptime(start_date_measure_pf_breakdown, "%Y-%m-%d"),
        datetime.datetime.strptime(start_date_measure_descriptive_stats, "%Y-%m-%d"),
        datetime.datetime.strptime(start_date_measure_med_counts, "%Y-%m-%d"),
    )

    end = max(
        datetime.datetime.strptime(index_date_dataset_tables, "%Y-%m-%d"),
        datetime.datetime.strptime(start_date_measure_condition_provider, "%Y-%m-%d")
        + relativedelta(months=monthly_intervals_measure_condition_provider),
        datetime.datetime.strptime(start_date_measure_pf_breakdown, "%Y-%m-%d")
        + relativedelta(months=monthly_intervals_measure_pf_breakdown),
        datetime.datetime.strptime(start_date_measure_descriptive_stats, "%Y-%m-%d")
        + relativedelta(months=monthly_intervals_measure_descriptive_stats),
        datetime.datetime.strptime(start_date_measure_med_counts, "%Y-%m-%d")
        + relativedelta(months=monthly_intervals_measure_med_counts),
    )
    return start.date(), end.date()
