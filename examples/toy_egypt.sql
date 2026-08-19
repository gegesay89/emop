-- Toy Egyptian overlay on an empty EMOP schema.
-- Fictional person. Not a real record.

INSERT INTO emop.location (
    location_id, city, county, location_source_value, country_source_value
) VALUES
    (1, 'Cairo', 'Cairo', 'EX-LOC-CAI-1', 'Egypt'),
    (2, 'Cairo', 'Cairo', 'EX-LOC-CAI-2', 'Egypt');

INSERT INTO emop.care_site (
    care_site_id, care_site_name, location_id, care_site_source_value, place_of_service_source_value
) VALUES
    (1, 'Example primary care unit', 1, 'EX-FAC-PHC-001', 'primary'),
    (2, 'Example specialty hospital', 2, 'EX-FAC-HOSP-001', 'hospital');

INSERT INTO emop.facility_extension (
    care_site_id, moh_facility_code, facility_sector, governorate_id, urban_rural, teaching_facility_flag, example_not_official
) VALUES
    (1, 'EX-MOH-FAC-001', 'public', 1, 'urban', 0, TRUE),
    (2, 'EX-MOH-FAC-002', 'university', 1, 'urban', 1, TRUE);

INSERT INTO emop.person (
    person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth,
    race_concept_id, ethnicity_concept_id, location_id, care_site_id, person_source_value,
    gender_source_value
) VALUES (
    1, 2000000902, 1984, 3, 12,
    2000000903, 2000000904, 1, 1, 'EX-PERSON-001', 'F'
);

INSERT INTO emop.person_name_bilingual (
    person_id, given_name_en, family_name_en, given_name_ar, family_name_ar, preferred_language
) VALUES (
    1, 'Mona', 'Mithal', 'منى', 'مثال', 'ar'
);

INSERT INTO emop.national_identifier (
    national_identifier_id, person_id, identifier_type, identifier_source_value,
    valid_start_date, example_not_official
) VALUES (
    1, 1, 'national_id', 'EX-NID-000001', DATE '2010-01-01', TRUE
);

INSERT INTO emop.person_insurance (
    person_insurance_id, person_id, insurance_scheme_id, coverage_start_date,
    subscriber_source_value, example_not_official
) VALUES (
    1, 1, 1, DATE '2024-01-01', 'EX-UHIA-SUB-001', TRUE
);

INSERT INTO emop.observation_period (
    observation_period_id, person_id, observation_period_start_date, observation_period_end_date,
    period_type_concept_id
) VALUES (
    1, 1, DATE '2024-01-01', DATE '2026-08-19', 2000000912
);

INSERT INTO emop.visit_occurrence (
    visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_end_date,
    visit_type_concept_id, care_site_id, visit_source_value
) VALUES (
    1, 1, 2000000910, DATE '2026-03-02', DATE '2026-03-02',
    2000000911, 1, 'EX-VIS-PHC-001'
);

INSERT INTO emop.referral (
    referral_id, person_id, from_care_site_id, to_care_site_id,
    referring_visit_occurrence_id, referral_date, referral_priority,
    referral_reason_source_value, example_not_official
) VALUES (
    1, 1, 1, 2, 1, DATE '2026-03-02', 'routine', 'EX-MOH-PROC-001', TRUE
);

INSERT INTO emop.visit_occurrence (
    visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_end_date,
    visit_type_concept_id, care_site_id, visit_source_value, preceding_visit_occurrence_id
) VALUES (
    2, 1, 2000000910, DATE '2026-03-10', DATE '2026-03-10',
    2000000911, 2, 'EX-VIS-HOSP-001', 1
);

INSERT INTO emop.visit_care_context (
    visit_occurrence_id, care_sector_id, insurance_scheme_id, referral_id, emergency_flag, example_not_official
) VALUES
    (1, 1, 1, NULL, 0, TRUE),
    (2, 4, 1, 1, 0, TRUE);

INSERT INTO emop.condition_occurrence (
    condition_occurrence_id, person_id, condition_concept_id, condition_start_date,
    condition_type_concept_id, visit_occurrence_id, condition_source_value
) VALUES (
    1, 1, 2000001201, DATE '2026-03-10', 2000000920, 2, 'E11.9'
);

INSERT INTO emop.drug_exposure (
    drug_exposure_id, person_id, drug_concept_id, drug_exposure_start_date, drug_exposure_end_date,
    drug_type_concept_id, days_supply, visit_occurrence_id, drug_source_value
) VALUES (
    1, 1, 2000001001, DATE '2026-03-10', DATE '2026-04-09',
    2000000913, 30, 2, 'EX-EDRUG-001'
);
