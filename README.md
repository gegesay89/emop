# EMOP Common Data Model

EMOP is an Egyptian profile of the OMOP Common Data Model. The core clinical tables keep their OMOP 5.4 names and grain (`PERSON`, `VISIT_OCCURRENCE`, `CONDITION_OCCURRENCE`, and the rest). Extra tables sit beside them for facts that Egyptian care actually records: national identifiers, governorates, insurance schemes, civil and military care, referrals, bilingual names, and national source codes.

This is a named product, not a rename of OMOP. The OMOP 5.4 layout in this repository is the OHDSI Common Data Model, Apache License 2.0, from tag `v5.4.2`. The Egyptian tables, example vocabularies, and documentation are separate work.

Site: [gegesay89.github.io/emop](https://gegesay89.github.io/emop/)

## What v0.1 contains

- PostgreSQL DDL for OMOP CDM 5.4 in schema `emop`
- Egyptian extension tables (see [docs/tables.md](docs/tables.md))
- Example vocabularies, clearly marked **not official**
- A table-by-table crosswalk back to OMOP ([docs/crosswalk-omop.md](docs/crosswalk-omop.md))
- A short FHIR mapping note ([docs/fhir-mapping.md](docs/fhir-mapping.md))
- One fictional person in [examples/toy_egypt.sql](examples/toy_egypt.sql)

OHDSI Atlas and network studies expect a stock OMOP instance. They will not see the Egyptian tables unless you map through the crosswalk. That is expected for this profile.

## Install

PostgreSQL 14 or newer.

```bash
createdb emop
./ddl/install.sh postgres://localhost/emop
psql postgres://localhost/emop -v ON_ERROR_STOP=1 -f vocabulary/load_examples.sql
psql postgres://localhost/emop -v ON_ERROR_STOP=1 -f examples/toy_egypt.sql
```

That yields 52 tables — 39 from the OMOP core, 13 Egyptian — plus the 27 governorates and one fictional patient journey. Applying the OHDSI foreign-key and index files on top brings the schema to 194 foreign keys; see [ddl/README.md](ddl/README.md) for the order and for what changes when you load a real Athena vocabulary instead of the examples.

## Example codes

Invented clinical and tariff codes use an `EX-` prefix and `example_not_official = true`. They are there so the repository is browsable. They are not Ministry of Health, UHIA, or HIO releases.

Governorate codes are ISO 3166-2:EG. Those are geographic codes, not a clinical terminology.

Read [vocabulary/EXAMPLE_NOT_OFFICIAL.md](vocabulary/EXAMPLE_NOT_OFFICIAL.md) before citing any code from this repository.

## Related work

- [OHDSI Common Data Model](https://github.com/OHDSI/CommonDataModel)
- [COE](https://github.com/gegesay89/coe-corpus-ontology-enricher), the corpus ontology enricher published alongside EMOP

## License

Apache License 2.0. See [LICENSE](LICENSE) and [NOTICE](NOTICE).

## Citation

See [CITATION.cff](CITATION.cff).
