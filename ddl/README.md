# Installing the EMOP schema

EMOP lives in one PostgreSQL schema named `emop`. Core tables are OMOP CDM 5.4 with the original names. Egyptian tables are added beside them.

Pinned OMOP source: OHDSI/CommonDataModel tag `v5.4.2`, Apache License 2.0.

## Default install (schema you can load examples into)

The OHDSI foreign-key file assumes a full Athena vocabulary already sits in `concept`. Skip it until that vocabulary is loaded.

```bash
./ddl/install.sh "$DATABASE_URL"
```

This runs, in order:

1. `00_create_schema.sql`
2. `omop_cdm_5.4/OMOPCDM_postgresql_5.4_ddl.sql`
3. `omop_cdm_5.4/OMOPCDM_postgresql_5.4_primary_keys.sql`
4. `emop_extension.sql`

Then optionally:

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f vocabulary/load_examples.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f examples/toy_egypt.sql
```

## After an Athena vocabulary load

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f ddl/omop_cdm_5.4/OMOPCDM_postgresql_5.4_constraints.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f ddl/omop_cdm_5.4/OMOPCDM_postgresql_5.4_indices.sql
```

Do not run `vocabulary/load_examples.sql` against a production vocabulary database. The example `concept_id` values sit in the local range at 2,000,000,000 and above, which is the OHDSI convention for site-local concepts, but the rows themselves are illustrative.
