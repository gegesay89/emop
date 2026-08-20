# FHIR mapping (v0.1)

Resource names follow FHIR R4. This document is a **mapping note plus a terminology package**, not an Implementation Guide — see [Scope](#scope) for why that distinction is deliberate.

## What ships

| Artifact | Path |
|---|---|
| Governorates | `fhir/CodeSystem-emop-governorate.json` |
| Insurance schemes | `fhir/CodeSystem-emop-insurance-scheme.json` |
| Care sectors | `fhir/CodeSystem-emop-care-sector.json` |
| Patient identifier types | `fhir/CodeSystem-emop-identifier-type.json` |
| A `ValueSet` per code system | `fhir/ValueSet-emop-*.json` |
| National codes to standard concepts | `fhir/ConceptMap-emop-source-code-map.json` |
| Everything in one collection | `fhir/Bundle-emop-terminology.json` |

All ten resources validate against the official FHIR R4 JSON schema (`http://hl7.org/fhir/json-schema/4.0`). They are generated from `vocabulary/load_examples.sql` by `fhir/build_terminology.py`, so the published codes cannot drift from the database:

```bash
python3 fhir/build_terminology.py
```

Load the bundle into any FHIR terminology server, or post the resources individually.

```bash
curl -X POST -H 'Content-Type: application/fhir+json' \
  --data-binary @fhir/Bundle-emop-terminology.json \
  https://your-fhir-server/fhir
```

Canonical URLs are under `https://gegesay89.github.io/emop/fhir/`. Every resource is `status: draft` and `experimental: true`.

## Resource correspondence

| FHIR R4 | EMOP |
|---|---|
| `Patient` | `person` plus `person_name_bilingual` |
| `Patient.identifier` | `national_identifier` |
| `Patient.address` / `Location` | `location`, `governorate` |
| `Encounter` | `visit_occurrence` plus `visit_care_context` |
| `Encounter` referral fields | `referral` |
| `Condition` | `condition_occurrence` |
| `MedicationRequest` / `MedicationStatement` | `drug_exposure` |
| `Procedure` | `procedure_occurrence` |
| `Observation` | `measurement`, `observation` |
| `Organization` | `care_site` plus `facility_extension` |
| `Practitioner` | `provider` |
| `Coverage` | `person_insurance` plus `insurance_scheme` |
| CodeableConcept | `source_code` through `source_code_omop_map` into `concept` |

## Element-level mapping

Four resources carry the Egyptian specifics. These are the elements where a generic mapping is not enough.

### Patient.identifier

One entry per `national_identifier` row. A patient holding a national identity number and a passport produces two entries, never one overloaded field.

| FHIR element | Source | Note |
|---|---|---|
| `identifier.type.coding.system` | fixed | `…/CodeSystem/emop-identifier-type` |
| `identifier.type.coding.code` | `identifier_type` | `national_id`, `passport`, `military_id`, `refugee` |
| `identifier.value` | `identifier_source_value` | |
| `identifier.system` | assigning authority | A URI naming the issuer, not the code above |
| `identifier.period.start` | `valid_start_date` | |
| `identifier.period.end` | `valid_end_date` | Omit while current |
| `identifier.use` | derived | `official` for the national identity number |

```json
{
  "resourceType": "Patient",
  "identifier": [
    {
      "use": "official",
      "type": {
        "coding": [
          {
            "system": "https://gegesay89.github.io/emop/fhir/CodeSystem/emop-identifier-type",
            "code": "national_id",
            "display": "National identity number"
          }
        ]
      },
      "system": "urn:oid:example.authority.eg",
      "value": "EX-NID-000001",
      "period": { "start": "2010-01-01" }
    }
  ]
}
```

**Do not place a national identity number in `Patient.id`.** `Patient.id` is a server key, meaningless outside the system that issued it. A national identifier is a real-world identifier that must survive being moved between systems. Conflating them makes re-linking unreliable and leaks the identifier into every URL that references the patient.

### Patient.name

`person_name_bilingual` holds both forms. FHIR carries both on one resource.

| FHIR element | Source |
|---|---|
| `name[x].given` / `name[x].family` | `given_name_ar` / `family_name_ar`, and the English pair |
| `name[x].use` | `official` on the legal name |
| `name[x].extension` | Language of that name, where the receiver needs it |

`preferred_language` states which form to display; it does not mean the other form should be dropped. When the Arabic form is the legal name, mark it `use: official` and keep the Latin form as an additional entry.

### Coverage

| FHIR element | Source | Note |
|---|---|---|
| `Coverage.payor` | `insurance_scheme` | Reference an `Organization`, identified by `scheme_code` |
| `Coverage.type.coding.system` | fixed | `…/CodeSystem/emop-insurance-scheme` |
| `Coverage.type.coding.code` | `scheme_code` | `UHIA`, `HIO`, `AFMS`, `POLICE`, `PRIVATE`, `OOP` |
| `Coverage.period.start` / `.end` | `coverage_start_date` / `coverage_end_date` | |
| `Coverage.subscriberId` | `subscriber_source_value` | |
| `Coverage.beneficiary` | `person_id` | Reference to `Patient` |
| `Coverage.status` | derived | `active` while `coverage_end_date` is null |

Overlapping coverage is legitimate — supplementary private cover alongside a public scheme is common — so emit one `Coverage` per `person_insurance` row rather than collapsing to one.

### Organization

| FHIR element | Source | Note |
|---|---|---|
| `Organization.identifier` | `moh_facility_code` | Illustrative in v0.1 |
| `Organization.name` | `care_site_name` | |
| `Organization.address.state` | `governorate` | Use the governorate code system |
| `Organization.type` | `facility_sector` | `public`, `private`, `university`, `military`, `ngo`, `police` |

There is no standard FHIR concept for teaching status or urban/rural catchment. Carry them as extensions or omit them; do not overload `Organization.type`.

### Encounter

| FHIR element | Source | Note |
|---|---|---|
| `Encounter.class` | `visit_concept_id` | |
| `Encounter.serviceProvider` | `care_site_id` | |
| `Encounter.priority` | `referral.referral_priority` | `routine`, `urgent`, `emergency` |
| `Encounter.basedOn` | `referral` | Reference a `ServiceRequest` if you model referrals as requests |
| `Encounter.period` | `visit_start_date`, `visit_end_date` | |

`visit_care_context.care_sector_id` has no standard element. The honest options are an extension or an `Observation`; inventing a field on `Encounter` is not one of them.

## Coded values in both directions

When exporting a diagnosis or procedure, emit **two codings on the same element**: the national source code, and the standard concept it maps to. The receiving system uses whichever it understands, and the mapping stays auditable.

```json
{
  "code": {
    "coding": [
      { "system": "https://gegesay89.github.io/emop/fhir/CodeSystem/icd10-eg", "code": "E11.9" },
      { "system": "http://snomed.info/sct", "code": "44054006" }
    ]
  }
}
```

The `ConceptMap` records, per mapping, whether the source code is genuinely published or illustrative. Codes prefixed `EX-` are illustrative and are issued by no Egyptian authority.

## Scope

This is not an Implementation Guide, and that is a deliberate decision rather than an unfinished one.

An Implementation Guide asserts conformance rules — which elements are mandatory, which bindings are required, what makes a payload valid. Egypt has no publicly codified national FHIR guide to align those rules to. Publishing profiles now would mean guessing at national requirements and presenting the guess as a standard, which is the same overreach as inventing Ministry of Health codes. See [design principles](../docs/overview.md).

What can be published honestly today is **terminology**: the governorates, the payer organisations, the care sectors, the identifier types, and the mapping table. Those are facts. Conformance rules are not, yet.

A future release can add profiles and `StructureMap` resources once there is a national guide to conform to, or once an implementer states their constraints.
