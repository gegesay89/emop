# Example vocabularies

Rows in this folder are for browsing the model. They are **not** official Egyptian code lists.

| File | Status |
|---|---|
| `governorate.csv` | ISO 3166-2:EG geographic codes. Not clinical. |
| `insurance_scheme.csv` | Public names of payer organisations. Not a benefit schedule. |
| `care_sector.csv` | Civil / military / police / university. |
| `moh_procedure.example.csv` | Invented `EX-MOH-PROC-*` codes. |
| `egyptian_drug.example.csv` | Invented `EX-EDRUG-*` codes. |
| `icd10_eg.example.csv` | Real WHO ICD-10 codes and titles; the Arabic labels are illustrative translations. |
| `uhia_service.example.csv` | Invented `EX-UHIA-*` codes. |

Invented clinical and tariff codes carry `example_not_official=true` and an `EX-` prefix. Rows whose code is genuinely published — the ISO governorate codes and the WHO ICD-10 codes — carry `example_not_official=false`, because the code itself is real even when the Arabic label beside it is not an official Egyptian release. The `attribution` column on `icd10_eg.example.csv` and the `official_status` value on each `source_vocabulary` row record which case applies.

Load the SQL form, not the CSV, into PostgreSQL:

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f vocabulary/load_examples.sql
```
