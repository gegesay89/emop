# FHIR terminology resources

Ten FHIR R4 resources generated from the EMOP reference data. All validate against the official FHIR R4 JSON schema (`http://hl7.org/fhir/json-schema/4.0`).

| File | Resource | Content |
|---|---|---|
| `CodeSystem-emop-governorate.json` | CodeSystem | 27 governorates, ISO 3166-2 codes, Arabic and English |
| `CodeSystem-emop-insurance-scheme.json` | CodeSystem | 6 payer organisations |
| `CodeSystem-emop-care-sector.json` | CodeSystem | 4 care sectors |
| `CodeSystem-emop-identifier-type.json` | CodeSystem | 4 patient identifier types |
| `ValueSet-emop-*.json` | ValueSet | One per code system, for element binding |
| `ConceptMap-emop-source-code-map.json` | ConceptMap | 7 national codes to standard concepts |
| `Bundle-emop-terminology.json` | Bundle | All of the above as one collection |

## Regenerating

Resources are derived from `vocabulary/load_examples.sql`, so they cannot drift from the database:

```bash
python3 fhir/build_terminology.py
```

No dependencies beyond the standard library. Edit the SQL, re-run, commit both.

## Loading

```bash
curl -X POST -H 'Content-Type: application/fhir+json' \
  --data-binary @fhir/Bundle-emop-terminology.json \
  https://your-fhir-server/fhir
```

## Status of the content

Every resource is `status: draft` and `experimental: true`.

**Genuinely published, usable as-is:** governorates (ISO 3166-2 geographic codes), payer organisation names, care sectors, identifier types.

**Illustrative:** the clinical and tariff codes in the `ConceptMap`. Codes prefixed `EX-` are issued by no Egyptian authority, and each mapping carries a comment saying so. The two ICD-10 rows are real international codes; only their Arabic labels are illustrative translations.

No benefit schedule, tariff, or eligibility rule is included anywhere.

## What is not here

No `StructureDefinition` profiles and no `StructureMap` resources. Egypt has no publicly codified national FHIR implementation guide, so conformance rules would be a guess presented as a standard. See [docs/fhir-mapping.md](../docs/fhir-mapping.md#scope).
