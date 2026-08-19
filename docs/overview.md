# EMOP overview

EMOP (Egyptian Medical Observational Profile) is a PostgreSQL schema for observational health data collected in Egypt.

## Design rules

1. **Keep OMOP names.** `PERSON` is still `PERSON`. A programmer who knows OMOP 5.4 can read the core without a new glossary.
2. **Add Egyptian tables beside the core.** Do not overload `observation` or `note` as a dumping ground for national ID, UHIA coverage, or bilingual legal names.
3. **Local concepts live at `concept_id` 2,000,000,000 and above**, which is the OHDSI convention for site-local concepts.
4. **Official code lists are not invented.** Public example rows are stamped `example_not_official`. ISO governorate codes are the exception: they are real geographic codes.

## Egyptian tables

| Table | Holds |
|---|---|
| `governorate` | 27 governorates, ISO 3166-2:EG, Arabic and English names |
| `national_identifier` | National ID, passport, military ID, other identifier types for a person |
| `facility_extension` | Ministry facility code, sector, governorate, teaching flag on a `CARE_SITE` |
| `insurance_scheme` | UHIA, HIO, armed forces, police, private, out of pocket |
| `person_insurance` | Coverage periods |
| `care_sector` | Civil, military, police, university |
| `referral` | From facility, to facility, date, priority |
| `visit_care_context` | Sector, payer, and referral on a visit |
| `person_name_bilingual` | English and Arabic given and family names, preferred language |
| `source_vocabulary` | Named national code systems |
| `source_code` | Codes in those systems |
| `source_code_omop_map` | Maps those codes onto `CONCEPT` |
| `emop_cdm_source` | EMOP version metadata |

## What this is not

- Not a fork that renames OMOP tables.
- Not an official Ministry of Health publication.
- Not a drop-in replacement for Atlas without an ETL back to stock OMOP.
