# Example vocabularies

Rows in this folder are for browsing the model. They are **not** official Egyptian code lists.

| File | Status |
|---|---|
| `governorate.csv` | ISO 3166-2:EG geographic codes. Not clinical. |
| `insurance_scheme.csv` | Public names of payer organisations. Not a benefit schedule. |
| `care_sector.csv` | Civil / military / police / university. |
| `moh_procedure.example.csv` | Invented `EX-MOH-PROC-*` codes. |
| `egyptian_drug.example.csv` | Invented `EX-EDRUG-*` codes. |
| `icd10_eg.example.csv` | WHO ICD-10 codes with Arabic labels for layout only. |
| `uhia_service.example.csv` | Invented `EX-UHIA-*` codes. |

Every invented clinical or tariff code has `example_not_official=true` and a prefix `EX-`.

Load the SQL form, not the CSV, into PostgreSQL:

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f vocabulary/load_examples.sql
```
