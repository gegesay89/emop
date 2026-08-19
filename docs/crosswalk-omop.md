# Crosswalk to OMOP CDM 5.4

Every core EMOP table is the OMOP 5.4 table of the same name. ETL that already writes OMOP can load the core without renaming columns.

Egyptian tables have no OMOP twin. To participate in an OHDSI network study, map them as follows or leave them behind.

| EMOP table | OMOP landing | Rule |
|---|---|---|
| `governorate` | `location` | One `location` row per governorate if you need Atlas geo filters. Keep `governorate` as the Egyptian source of truth. |
| `national_identifier` | none | Do not put national IDs in `person.person_source_value` if you also need passport or military ID. Network extracts should drop this table. |
| `facility_extension` | `care_site` | `moh_facility_code` may copy to `care_site_source_value`. Sector and teaching flag have no OMOP column; omit them from network extracts. |
| `insurance_scheme` | `payer_plan_period.payer_source_value` | Use `scheme_code` as the payer source value. |
| `person_insurance` | `payer_plan_period` | One period row per coverage interval. |
| `care_sector` | none, or `observation` | If a study needs civil vs military, emit an observation with a mapped concept; do not invent an OMOP column. |
| `referral` | none, or `fact_relationship` between two `visit_occurrence` rows | Prefer keeping `referral` locally. |
| `visit_care_context` | `visit_occurrence` | Emergency can map to visit concept. Payer stays in `payer_plan_period`. |
| `person_name_bilingual` | none | OMOP `person` has no name columns. Keep names out of network extracts. |
| `source_vocabulary` / `source_code` | `vocabulary` / `concept` / `source_to_concept_map` | Load official lists into the OHDSI vocabulary tables when you have redistribution rights. The EMOP tables are the working area before that load. |
| `source_code_omop_map` | `source_to_concept_map` | Same grain: source code to standard `concept_id`. |
| `emop_cdm_source` | `cdm_source` | Keep both. `cdm_source` carries the OMOP version an OHDSI tool reads; `emop_cdm_source` records which EMOP release produced the instance. Drop the EMOP row from network extracts. |

Local `concept_id` values in this repository start at 2,000,000,000. They must not collide with Athena standard IDs.

A network extract that drops every Egyptian table and keeps the OMOP-named core is a valid OMOP 5.4 instance, provided gender, visit, and type concepts have been remapped from the example 2e9 IDs onto standard Athena concepts.
