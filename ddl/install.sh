#!/bin/sh
# Apply the EMOP schema (OMOP 5.4 core + Egyptian extension tables).
# Usage: ./ddl/install.sh postgres://user@localhost/emop
set -eu
if [ "${1:-}" = "" ]; then
  echo "usage: $0 DATABASE_URL" >&2
  exit 1
fi
URL=$1
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
psql "$URL" -v ON_ERROR_STOP=1 -f "$ROOT/00_create_schema.sql"
psql "$URL" -v ON_ERROR_STOP=1 -f "$ROOT/omop_cdm_5.4/OMOPCDM_postgresql_5.4_ddl.sql"
psql "$URL" -v ON_ERROR_STOP=1 -f "$ROOT/omop_cdm_5.4/OMOPCDM_postgresql_5.4_primary_keys.sql"
psql "$URL" -v ON_ERROR_STOP=1 -f "$ROOT/emop_extension.sql"
echo "EMOP schema applied. Load vocabulary/load_examples.sql next if you want the example rows."
