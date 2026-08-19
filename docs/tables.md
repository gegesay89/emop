# EMOP tables

Schema: `emop`. Version: 0.1.0. OMOP core: CDM 5.4.

## Core (OMOP 5.4 names)

Clinical: `person`, `observation_period`, `visit_occurrence`, `visit_detail`, `condition_occurrence`, `drug_exposure`, `procedure_occurrence`, `device_exposure`, `measurement`, `observation`, `death`, `note`, `note_nlp`, `specimen`, `fact_relationship`, `episode`, `episode_event`

Health system: `location`, `care_site`, `provider`

Economic: `payer_plan_period`, `cost`

Derived: `drug_era`, `dose_era`, `condition_era`

Vocabulary: `concept`, `vocabulary`, `domain`, `concept_class`, `concept_relationship`, `relationship`, `concept_synonym`, `concept_ancestor`, `source_to_concept_map`, `drug_strength`

Metadata: `cdm_source`, `metadata`

Column definitions for these tables are the OHDSI 5.4 DDL vendored in `ddl/omop_cdm_5.4/`.

## Egyptian extension

Defined in `ddl/emop_extension.sql`.

### governorate

| Column | Type | Notes |
|---|---|---|
| governorate_id | integer | Primary key |
| governorate_code | varchar(16) | Short code, unique |
| governorate_name_en | varchar(255) | |
| governorate_name_ar | varchar(255) | |
| region_name_en | varchar(255) | Greater Cairo, Delta, Canal, Sinai, Upper Egypt, Frontier |
| region_name_ar | varchar(255) | |
| location_id | integer | Optional link to `location` |
| iso_3166_2 | varchar(16) | e.g. EG-C |
| example_not_official | boolean | false for ISO rows |

### national_identifier

| Column | Type | Notes |
|---|---|---|
| national_identifier_id | integer | Primary key |
| person_id | integer | `person` |
| identifier_type | varchar(64) | `national_id`, `passport`, `military_id`, `refugee` |
| identifier_type_concept_id | integer | Optional |
| identifier_source_value | varchar(128) | Public examples are fictional (`EX-NID-…`) |
| valid_start_date | date | |
| valid_end_date | date | |
| example_not_official | boolean | |

### facility_extension

One optional row per `care_site`.

| Column | Type | Notes |
|---|---|---|
| care_site_id | integer | Primary key, `care_site` |
| moh_facility_code | varchar(64) | Example values only in v0.1 |
| facility_sector | varchar(32) | `public`, `private`, `university`, `military`, `ngo`, `police` |
| governorate_id | integer | |
| urban_rural | varchar(16) | |
| teaching_facility_flag | integer | 0/1 |
| example_not_official | boolean | |

### insurance_scheme

| Column | Type | Notes |
|---|---|---|
| insurance_scheme_id | integer | |
| scheme_code | varchar(32) | UHIA, HIO, AFMS, POLICE, PRIVATE, OOP |
| scheme_name_en | varchar(255) | |
| scheme_name_ar | varchar(255) | |
| scheme_type | varchar(32) | `social`, `military`, `private`, `out_of_pocket` |
| example_not_official | boolean | false for organisation names |

### person_insurance

Coverage period for a person and a scheme.

### care_sector

`CIVIL`, `MILITARY`, `POLICE`, `UNIVERSITY`.

### referral

From `care_site` to `care_site`, optional originating visit, priority `routine` / `urgent` / `emergency`.

### visit_care_context

One optional row per `visit_occurrence`: sector, scheme, referral, emergency flag.

### person_name_bilingual

One row per person. `preferred_language` is `ar` or `en`.

### source_vocabulary, source_code, source_code_omop_map

National code systems, their codes, and maps onto `concept`. Parallel to OMOP `source_to_concept_map`, with Arabic names and an explicit `example_not_official` flag.

### emop_cdm_source

EMOP version, OMOP version, release date.
