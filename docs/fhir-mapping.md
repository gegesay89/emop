# FHIR mapping (v0.1 note)

This is a mapping note, not a FHIR Implementation Guide. Resource names follow FHIR R4.

| FHIR R4 | EMOP |
|---|---|
| `Patient` | `person` plus `person_name_bilingual` |
| `Patient.identifier` | `national_identifier` |
| `Patient.address` / `Location` | `location`, `governorate` |
| `Encounter` | `visit_occurrence` plus `visit_care_context` |
| `Encounter.hospitalization.origin` / referral | `referral` |
| `Condition` | `condition_occurrence` |
| `MedicationRequest` / `MedicationStatement` | `drug_exposure` |
| `Procedure` | `procedure_occurrence` |
| `Observation` | `measurement`, `observation` |
| `Organization` | `care_site` plus `facility_extension` |
| `Practitioner` | `provider` |
| `Coverage` | `person_insurance` and `insurance_scheme` |
| `Coverage.payor` | `insurance_scheme.scheme_code` (UHIA, HIO, AFMS, …) |
| CodeableConcept | `source_code` mapped through `source_code_omop_map` into `concept` |

Language: `person_name_bilingual.preferred_language` is `ar` or `en`. FHIR `HumanName` can carry both; store Arabic in `name` with `use=official` when that is the legal name.

Do not place a national ID in `Patient.id`. `Patient.id` is the system key; `national_identifier.identifier_source_value` is the identifier.

A later release can publish StructureMaps. v0.1 stops at this table so the CDM can ship without pretending an IG exists.
