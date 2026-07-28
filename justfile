set dotenv-load := true

OPENSAFELY_CLI_DIR := "${REPOS_DIR}/opensafely-cli"
EHRQL_DIR := "${REPOS_DIR}/ehrql"

venv:
    test -d .venv/ || uv venv --python 3.13
    uv pip install setuptools
    uv pip install ruff

build-ehrql-dev-image:
    #!/usr/bin/env bash
    cd {{ EHRQL_DIR }} && set -a && source .env && set +a && just build-ehrql-for-os-cli

install-opensafely-cli:
    #!/usr/bin/env bash
    if [ ! -f .venv/.opensafely-installed ] || [ {{ OPENSAFELY_CLI_DIR }}/pyproject.toml -nt .venv/.opensafely-installed ]; then
        uv pip install -e {{ OPENSAFELY_CLI_DIR }} setuptools
        touch .venv/.opensafely-installed
    fi

opensafely *args: venv build-ehrql-dev-image install-opensafely-cli
    #!/usr/bin/env bash
    .venv/bin/opensafely {{ args }}

install-ehrql: venv
    #!/usr/bin/env bash
    if [ ! -f .venv/.ehrql-installed ] || [ {{ EHRQL_DIR }}/pyproject.toml -nt .venv/.ehrql-installed ]; then
        uv pip install -e {{ EHRQL_DIR }}
        touch .venv/.ehrql-installed
    fi

dummy-tables: install-ehrql
    uv pip install pandas
    .venv/bin/ehrql create-dummy-tables analysis/dummy_tables/dummy_data_definition.py dummy_tables/
    rm dummy_tables/addresses.csv
    .venv/bin/python scripts/get_lsoa_subset_and_assign_to_patients.py
    .venv/bin/python scripts/generate_clinical_events_and_medications.py

ehrql *args: venv install-ehrql
    .venv/bin/ehrql {{ args }}

@nuke:
    rm -rf metadata/ && mkdir metadata
    rm -rf output/ && mkdir output
    touch output/.gitkeep

fix: venv
    .venv/bin/ruff format .
    .venv/bin/ruff check --fix .
