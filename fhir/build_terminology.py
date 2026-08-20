#!/usr/bin/env python3
"""Generate FHIR R4 terminology resources from the EMOP reference data.

Codes are read out of vocabulary/load_examples.sql rather than restated here,
so the published resources cannot drift from the database. Run from the
repository root:

    python3 fhir/build_terminology.py

Only reference data that is genuinely published is emitted as a CodeSystem:
governorates, insurance schemes, care sectors, and identifier types. The
illustrative clinical codes are emitted as a ConceptMap alongside an explicit
status of each source system, never as authoritative content.
"""

from __future__ import annotations

import json
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
SQL = ROOT / "vocabulary" / "load_examples.sql"
OUT = ROOT / "fhir"

BASE = "https://gegesay89.github.io/emop/fhir"
VERSION = "0.1.0"
DATE = "2026-08-20"
PUBLISHER = "Gehad Sayed Ahmed"
CONTACT = [{"telecom": [{"system": "url", "value": "https://github.com/gegesay89/emop"}]}]

AR = "urn:ietf:bcp:47|ar"
EN = "urn:ietf:bcp:47|en"


def sql_text() -> str:
    if not SQL.exists():
        sys.exit(f"missing {SQL}")
    return SQL.read_text(encoding="utf-8")


def rows_for(table: str, text: str) -> list[list[str]]:
    """Return the VALUES tuples of the first INSERT into `table`."""
    match = re.search(
        rf"INSERT INTO emop\.{table}\s*\((.*?)\)\s*VALUES\s*(.*?);",
        text,
        re.S,
    )
    if not match:
        sys.exit(f"no INSERT found for {table}")
    body = match.group(2)
    tuples = re.findall(r"\((.*?)\)(?=\s*(?:,\s*\(|\s*$))", body, re.S)
    parsed = []
    for raw in tuples:
        fields, buf, quoted = [], "", False
        i = 0
        while i < len(raw):
            ch = raw[i]
            if ch == "'":
                if quoted and i + 1 < len(raw) and raw[i + 1] == "'":
                    buf += "'"
                    i += 2
                    continue
                quoted = not quoted
                i += 1
                continue
            if ch == "," and not quoted:
                fields.append(buf.strip())
                buf = ""
                i += 1
                continue
            buf += ch
            i += 1
        fields.append(buf.strip())
        parsed.append(fields)
    return parsed


def designations(name_ar: str, name_en: str) -> list[dict]:
    return [
        {"language": "ar", "value": name_ar},
        {"language": "en", "value": name_en},
    ]


def code_system(
    *,
    ident: str,
    name: str,
    title: str,
    description: str,
    concepts: list[dict],
    copyright_note: str | None = None,
) -> dict:
    resource = {
        "resourceType": "CodeSystem",
        "id": ident,
        "url": f"{BASE}/CodeSystem/{ident}",
        "version": VERSION,
        "name": name,
        "title": title,
        "status": "draft",
        "experimental": True,
        "date": DATE,
        "publisher": PUBLISHER,
        "contact": CONTACT,
        "description": description,
        "caseSensitive": True,
        "valueSet": f"{BASE}/ValueSet/{ident}",
        "content": "complete",
        "count": len(concepts),
        "concept": concepts,
    }
    if copyright_note:
        resource["copyright"] = copyright_note
    return resource


def value_set(*, ident: str, name: str, title: str, description: str) -> dict:
    return {
        "resourceType": "ValueSet",
        "id": ident,
        "url": f"{BASE}/ValueSet/{ident}",
        "version": VERSION,
        "name": name,
        "title": title,
        "status": "draft",
        "experimental": True,
        "date": DATE,
        "publisher": PUBLISHER,
        "contact": CONTACT,
        "description": description,
        "compose": {"include": [{"system": f"{BASE}/CodeSystem/{ident}"}]},
    }


def build_governorates(text: str) -> list[dict]:
    concepts = []
    for row in rows_for("governorate", text):
        _id, code, name_en, name_ar, region_en, region_ar, iso, _flag = row
        concepts.append(
            {
                "code": code,
                "display": name_en,
                "designation": designations(name_ar, name_en),
                "property": [
                    {"code": "iso-3166-2", "valueString": iso},
                    {"code": "region", "valueString": region_en},
                    {"code": "region-ar", "valueString": region_ar},
                ],
            }
        )
    cs = code_system(
        ident="emop-governorate",
        name="EmopGovernorate",
        title="Egyptian governorates",
        description=(
            "The 27 governorates of Egypt with Arabic and English designations, the ISO 3166-2 "
            "subdivision code, and a regional grouping. These are geographic identifiers, not a "
            "clinical terminology."
        ),
        concepts=concepts,
        copyright_note=(
            "ISO 3166-2 subdivision codes are published by the International Organization for "
            "Standardization. Regional groupings and this packaging are the work of the publisher."
        ),
    )
    cs["property"] = [
        {"code": "iso-3166-2", "description": "ISO 3166-2:EG subdivision code", "type": "string"},
        {"code": "region", "description": "Regional grouping, English", "type": "string"},
        {"code": "region-ar", "description": "Regional grouping, Arabic", "type": "string"},
    ]
    return [
        cs,
        value_set(
            ident="emop-governorate",
            name="EmopGovernorateVS",
            title="Egyptian governorates",
            description="All 27 Egyptian governorates. Suitable for Address.state and Location.address.state.",
        ),
    ]


def build_insurance(text: str) -> list[dict]:
    concepts = []
    for row in rows_for("insurance_scheme", text):
        _id, code, name_en, name_ar, scheme_type, _flag = row
        concepts.append(
            {
                "code": code,
                "display": name_en,
                "designation": designations(name_ar, name_en),
                "property": [{"code": "scheme-type", "valueString": scheme_type}],
            }
        )
    cs = code_system(
        ident="emop-insurance-scheme",
        name="EmopInsuranceScheme",
        title="Egyptian health insurance schemes",
        description=(
            "Payer organisations operating in Egypt, for use as Coverage.payor and "
            "Coverage.type. Organisation names are public; this code system carries no benefit "
            "schedule, tariff, or eligibility rule."
        ),
        concepts=concepts,
    )
    cs["property"] = [
        {
            "code": "scheme-type",
            "description": "social, military, private, or out_of_pocket",
            "type": "string",
        }
    ]
    return [
        cs,
        value_set(
            ident="emop-insurance-scheme",
            name="EmopInsuranceSchemeVS",
            title="Egyptian health insurance schemes",
            description="Payer organisations for Coverage.payor and Coverage.type.",
        ),
    ]


def build_care_sector(text: str) -> list[dict]:
    concepts = []
    for row in rows_for("care_sector", text):
        _id, code, name_en, name_ar = row
        concepts.append(
            {
                "code": code,
                "display": name_en,
                "designation": designations(name_ar, name_en),
            }
        )
    return [
        code_system(
            ident="emop-care-sector",
            name="EmopCareSector",
            title="Egyptian care sectors",
            description=(
                "The parallel care systems through which health care is delivered in Egypt. "
                "Funding and governance differ between sectors, so the distinction is "
                "analytically material."
            ),
            concepts=concepts,
        ),
        value_set(
            ident="emop-care-sector",
            name="EmopCareSectorVS",
            title="Egyptian care sectors",
            description="Civil, military, police, and university care.",
        ),
    ]


# Identifier types are defined by the schema rather than by a data table.
IDENTIFIER_TYPES = [
    ("national_id", "National identity number", "الرقم القومي", "14 digits, issued nationally"),
    ("passport", "Passport number", "رقم جواز السفر", "Used where no national identity number exists"),
    ("military_id", "Military identity number", "الرقم العسكري", "Issued within the military care sector"),
    ("refugee", "Refugee registration number", "رقم تسجيل اللاجئ", "Issued by the registering agency"),
]


def build_identifier_types() -> list[dict]:
    concepts = [
        {
            "code": code,
            "display": display_en,
            "definition": definition,
            "designation": designations(display_ar, display_en),
        }
        for code, display_en, display_ar, definition in IDENTIFIER_TYPES
    ]
    return [
        code_system(
            ident="emop-identifier-type",
            name="EmopIdentifierType",
            title="Egyptian patient identifier types",
            description=(
                "Identifier types a patient may hold, for use as Patient.identifier.type. A "
                "patient may hold more than one; each is a separate Patient.identifier entry."
            ),
            concepts=concepts,
        ),
        value_set(
            ident="emop-identifier-type",
            name="EmopIdentifierTypeVS",
            title="Egyptian patient identifier types",
            description="Identifier types for Patient.identifier.type.",
        ),
    ]


def build_concept_map(text: str) -> dict:
    """Mirror source_code_omop_map, carrying each code's official status."""
    vocab = {}
    for row in rows_for("source_vocabulary", text):
        vocab[row[0]] = {"code": row[1], "name_en": row[2], "status": row[4]}

    codes = {}
    for row in rows_for("source_code", text):
        sid, vid, code, name_en, name_ar, domain, _start, _end, flag = row
        codes[sid] = {
            "vocab": vocab[vid],
            "code": code,
            "name_en": name_en,
            "name_ar": name_ar,
            "domain": domain,
            "illustrative": flag.strip().upper() == "TRUE",
        }

    concepts = {c["concept_id"]: c for c in _concepts(text)}

    groups: dict[str, list[dict]] = {}
    for row in rows_for("source_code_omop_map", text):
        sid, concept_id, relationship, _start, _end = row
        src = codes[sid]
        target = concepts.get(concept_id, {})
        groups.setdefault(src["vocab"]["code"], []).append(
            {
                "code": src["code"],
                "display": src["name_en"],
                "target": [
                    {
                        "code": target.get("concept_code", concept_id),
                        "display": target.get("concept_name", ""),
                        "equivalence": "equivalent" if relationship == "Maps to" else "relatedto",
                        "comment": (
                            "Illustrative source code, not an official Egyptian release."
                            if src["illustrative"]
                            else "Published source code; the Arabic label is an illustrative translation."
                        ),
                    }
                ],
            }
        )

    return {
        "resourceType": "ConceptMap",
        "id": "emop-source-code-map",
        "url": f"{BASE}/ConceptMap/emop-source-code-map",
        "version": VERSION,
        "name": "EmopSourceCodeMap",
        "title": "Egyptian source codes to standard concepts",
        "status": "draft",
        "experimental": True,
        "date": DATE,
        "publisher": PUBLISHER,
        "contact": CONTACT,
        "description": (
            "Mirrors emop.source_code_omop_map. Each group is one national code system; every "
            "mapping records whether its source code is a published code or an illustrative "
            "example. Codes prefixed EX- are illustrative and are not issued by any Egyptian "
            "authority."
        ),
        "purpose": (
            "Lets an exchange payload carry both the national source code and the standard "
            "concept it maps to, so a receiving system need not guess."
        ),
        "group": [
            {
                "source": f"{BASE}/CodeSystem/{name.lower().replace('_', '-')}",
                "target": f"{BASE}/CodeSystem/emop-example-concept",
                "element": elements,
            }
            for name, elements in sorted(groups.items())
        ],
    }


def _concepts(text: str) -> list[dict]:
    out = []
    for row in rows_for("concept", text):
        concept_id, concept_name, domain, vocab, cclass, standard, code, *_rest = row
        out.append({"concept_id": concept_id, "concept_name": concept_name, "concept_code": code})
    return out


def main() -> int:
    text = sql_text()
    OUT.mkdir(parents=True, exist_ok=True)

    resources: list[dict] = []
    resources += build_governorates(text)
    resources += build_insurance(text)
    resources += build_care_sector(text)
    resources += build_identifier_types()
    resources.append(build_concept_map(text))

    written = []
    for resource in resources:
        name = f"{resource['resourceType']}-{resource['id']}.json"
        path = OUT / name
        path.write_text(json.dumps(resource, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        written.append(path)

    bundle = {
        "resourceType": "Bundle",
        "id": "emop-terminology",
        "type": "collection",
        "timestamp": f"{DATE}T00:00:00Z",
        "entry": [
            {"fullUrl": r["url"], "resource": r}
            for r in resources
        ],
    }
    bundle_path = OUT / "Bundle-emop-terminology.json"
    bundle_path.write_text(json.dumps(bundle, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    written.append(bundle_path)

    for path in written:
        print(path.relative_to(ROOT))
    print(f"\n{len(written)} files written")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
