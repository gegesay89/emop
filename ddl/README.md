# Installing the EMOP schema

EMOP lives in one PostgreSQL schema named `emop`. Core tables are OMOP CDM 5.4 with the original names. Egyptian tables are added beside them.

Pinned OMOP source: OHDSI/CommonDataModel tag `v5.4.2`, Apache License 2.0.

## Default install (schema you can load examples into)

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

Result on a clean PostgreSQL 17 database: 52 tables, 27 governorates, and one fictional patient with two visits.

## Foreign keys and indexes

The example set is referentially complete — it includes `concept_id` 0, the `domain` and `concept_class` rows every example concept refers to, and the `vocabulary` row — so the OHDSI foreign-key file applies on top of it without error:

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f ddl/omop_cdm_5.4/OMOPCDM_postgresql_5.4_constraints.sql
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f ddl/omop_cdm_5.4/OMOPCDM_postgresql_5.4_indices.sql
```

That brings the schema to 194 foreign keys. Domain and class concept ids in the example set point at the EMOP metadata concept, because this release does not ship the OHDSI standard vocabulary.

## Loading a real vocabulary instead

If you are loading OHDSI Standardized Vocabularies from Athena, skip `vocabulary/load_examples.sql` entirely and apply the foreign-key file after that load. The example `concept_id` values sit at 2,000,000,000 and above, which is the OHDSI convention for site-local concepts, but the rows themselves are illustrative and would sit alongside real content confusingly.
