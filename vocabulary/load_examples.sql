-- Example reference rows for an empty EMOP schema.
-- Copyright 2026 Gehad Sayed Ahmed
-- Apache License 2.0
--
-- EXAMPLE_NOT_OFFICIAL: clinical and tariff codes in this file are
-- illustrative. They are not Ministry of Health, UHIA, or HIO releases.
-- Governorate rows use ISO 3166-2:EG (geographic codes).
--
-- Do not run this file against a database that already contains OHDSI
-- Standardized Vocabularies unless you have reviewed the 2e9 concept_id range.

INSERT INTO emop.emop_cdm_source (
    emop_cdm_source_name, emop_cdm_version, omop_cdm_version, emop_release_date, comment
) VALUES (
    'EMOP', '0.1.0', '5.4', DATE '2026-08-19',
    'Public example distribution. Clinical source codes are illustrative.'
);

INSERT INTO emop.cdm_source (
    cdm_source_name, cdm_source_abbreviation, cdm_holder, source_description,
    source_documentation_reference, cdm_etl_reference, source_release_date,
    cdm_release_date, cdm_version, cdm_version_concept_id, vocabulary_version
) VALUES (
    'EMOP example', 'EMOP', 'Gehad Sayed Ahmed',
    'Toy Egyptian overlay on OMOP CDM 5.4',
    'https://github.com/gegesay89/emop',
    'https://gegesay89.github.io/emop/',
    DATE '2026-08-19', DATE '2026-08-19', '5.4', 2000000000, 'EMOP-example-0.1'
);

INSERT INTO emop.concept (
    concept_id, concept_name, domain_id, vocabulary_id, concept_class_id,
    standard_concept, concept_code, valid_start_date, valid_end_date, invalid_reason
) VALUES
    (2000000000, 'EMOP CDM v0.1', 'Metadata', 'EMOP Example', 'CDM', 'S', 'EMOP_0_1', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000000801, 'Arabic', 'Language', 'EMOP Example', 'Language', 'S', 'ar', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000000802, 'English', 'Language', 'EMOP Example', 'Language', 'S', 'en', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000000901, 'Example male', 'Gender', 'EMOP Example', 'Gender', 'S', 'EX-G-M', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000000902, 'Example female', 'Gender', 'EMOP Example', 'Gender', 'S', 'EX-G-F', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000000903, 'Example race unspecified', 'Race', 'EMOP Example', 'Race', 'S', 'EX-R-U', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000000904, 'Example ethnicity unspecified', 'Ethnicity', 'EMOP Example', 'Ethnicity', 'S', 'EX-E-U', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000000910, 'Example outpatient visit', 'Visit', 'EMOP Example', 'Visit', 'S', 'EX-V-OP', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000000911, 'Example visit type', 'Type Concept', 'EMOP Example', 'Visit Type', 'S', 'EX-VT-1', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000000912, 'Example observation period type', 'Type Concept', 'EMOP Example', 'Period Type', 'S', 'EX-PT-1', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000000913, 'Example drug type', 'Type Concept', 'EMOP Example', 'Drug Type', 'S', 'EX-DT-1', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000000920, 'Example condition type', 'Type Concept', 'EMOP Example', 'Condition Type', 'S', 'EX-CT-1', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000001001, 'Example metformin 500 mg tablet', 'Drug', 'EMOP Example', 'Clinical Drug', 'S', 'EX-EDRUG-001', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000001002, 'Example amoxicillin 500 mg capsule', 'Drug', 'EMOP Example', 'Clinical Drug', 'S', 'EX-EDRUG-002', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000001101, 'Example outpatient surgical consultation', 'Procedure', 'EMOP Example', 'Procedure', 'S', 'EX-MOH-PROC-001', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000001102, 'Example haemoglobin laboratory test', 'Procedure', 'EMOP Example', 'Procedure', 'S', 'EX-MOH-PROC-002', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000001201, 'Example type 2 diabetes mellitus', 'Condition', 'EMOP Example', 'Clinical Finding', 'S', 'EX-ICD10-E11.9', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000001202, 'Example essential hypertension', 'Condition', 'EMOP Example', 'Clinical Finding', 'S', 'EX-ICD10-I10', DATE '2026-08-19', DATE '2099-12-31', NULL),
    (2000001301, 'Example UHIA outpatient visit line', 'Observation', 'EMOP Example', 'Service', 'S', 'EX-UHIA-OPD-001', DATE '2026-08-19', DATE '2099-12-31', NULL);

INSERT INTO emop.vocabulary (
    vocabulary_id, vocabulary_name, vocabulary_reference, vocabulary_version, vocabulary_concept_id
) VALUES (
    'EMOP Example',
    'EMOP example vocabulary (not official)',
    'https://github.com/gegesay89/emop',
    '0.1.0',
    2000000000
);

INSERT INTO emop.concept_synonym (concept_id, concept_synonym_name, language_concept_id) VALUES
    (2000001001, 'مثال ميتفورمين 500 ملغ', 2000000801),
    (2000001002, 'مثال أموكسيسيلين 500 ملغ', 2000000801),
    (2000001101, 'مثال استشارة جراحية خارجية', 2000000801),
    (2000001102, 'مثال تحليل هيموغلوبين', 2000000801),
    (2000001201, 'مثال سكري النمط الثاني', 2000000801),
    (2000001202, 'مثال فرط ضغط دم أساسي', 2000000801),
    (2000001301, 'مثال بند زيارة عيادات التأمين الشامل', 2000000801);

INSERT INTO emop.care_sector (care_sector_id, sector_code, sector_name_en, sector_name_ar) VALUES
    (1, 'CIVIL', 'Civil', 'مدني'),
    (2, 'MILITARY', 'Military', 'عسكري'),
    (3, 'POLICE', 'Police', 'شرطة'),
    (4, 'UNIVERSITY', 'University hospital', 'مستشفى جامعي');

INSERT INTO emop.insurance_scheme (
    insurance_scheme_id, scheme_code, scheme_name_en, scheme_name_ar, scheme_type, example_not_official
) VALUES
    (1, 'UHIA', 'Universal Health Insurance Authority', 'الهيئة العامة للتأمين الصحي الشامل', 'social', FALSE),
    (2, 'HIO', 'Health Insurance Organization', 'الهيئة العامة للتأمين الصحي', 'social', FALSE),
    (3, 'AFMS', 'Armed Forces Medical Services', 'الخدمات الطبية بالقوات المسلحة', 'military', FALSE),
    (4, 'POLICE', 'Police medical services', 'الخدمات الطبية للشرطة', 'military', FALSE),
    (5, 'PRIVATE', 'Private insurance', 'تأمين خاص', 'private', FALSE),
    (6, 'OOP', 'Out of pocket', 'إنفاق مباشر', 'out_of_pocket', FALSE);

INSERT INTO emop.governorate (
    governorate_id, governorate_code, governorate_name_en, governorate_name_ar,
    region_name_en, region_name_ar, iso_3166_2, example_not_official
) VALUES
    (1, 'C', 'Cairo', 'القاهرة', 'Greater Cairo', 'القاهرة الكبرى', 'EG-C', FALSE),
    (2, 'GZ', 'Giza', 'الجيزة', 'Greater Cairo', 'القاهرة الكبرى', 'EG-GZ', FALSE),
    (3, 'KB', 'Qalyubia', 'القليوبية', 'Greater Cairo', 'القاهرة الكبرى', 'EG-KB', FALSE),
    (4, 'ALX', 'Alexandria', 'الإسكندرية', 'Alexandria', 'الإسكندرية', 'EG-ALX', FALSE),
    (5, 'BH', 'Beheira', 'البحيرة', 'Delta', 'الدلتا', 'EG-BH', FALSE),
    (6, 'DK', 'Dakahlia', 'الدقهلية', 'Delta', 'الدلتا', 'EG-DK', FALSE),
    (7, 'GH', 'Gharbia', 'الغربية', 'Delta', 'الدلتا', 'EG-GH', FALSE),
    (8, 'KFS', 'Kafr el-Sheikh', 'كفر الشيخ', 'Delta', 'الدلتا', 'EG-KFS', FALSE),
    (9, 'MNF', 'Monufia', 'المنوفية', 'Delta', 'الدلتا', 'EG-MNF', FALSE),
    (10, 'SHR', 'Al Sharqia', 'الشرقية', 'Delta', 'الدلتا', 'EG-SHR', FALSE),
    (11, 'DT', 'Damietta', 'دمياط', 'Delta', 'الدلتا', 'EG-DT', FALSE),
    (12, 'IS', 'Ismailia', 'الإسماعيلية', 'Canal', 'القناة', 'EG-IS', FALSE),
    (13, 'PTS', 'Port Said', 'بورسعيد', 'Canal', 'القناة', 'EG-PTS', FALSE),
    (14, 'SUZ', 'Suez', 'السويس', 'Canal', 'القناة', 'EG-SUZ', FALSE),
    (15, 'SIN', 'North Sinai', 'شمال سيناء', 'Sinai', 'سيناء', 'EG-SIN', FALSE),
    (16, 'JS', 'South Sinai', 'جنوب سيناء', 'Sinai', 'سيناء', 'EG-JS', FALSE),
    (17, 'FYM', 'Faiyum', 'الفيوم', 'Upper Egypt', 'الصعيد', 'EG-FYM', FALSE),
    (18, 'BNS', 'Beni Suef', 'بني سويف', 'Upper Egypt', 'الصعيد', 'EG-BNS', FALSE),
    (19, 'MN', 'Minya', 'المنيا', 'Upper Egypt', 'الصعيد', 'EG-MN', FALSE),
    (20, 'AST', 'Asyut', 'أسيوط', 'Upper Egypt', 'الصعيد', 'EG-AST', FALSE),
    (21, 'SHG', 'Sohag', 'سوهاج', 'Upper Egypt', 'الصعيد', 'EG-SHG', FALSE),
    (22, 'KN', 'Qena', 'قنا', 'Upper Egypt', 'الصعيد', 'EG-KN', FALSE),
    (23, 'LX', 'Luxor', 'الأقصر', 'Upper Egypt', 'الصعيد', 'EG-LX', FALSE),
    (24, 'ASN', 'Aswan', 'أسوان', 'Upper Egypt', 'الصعيد', 'EG-ASN', FALSE),
    (25, 'BA', 'Red Sea', 'البحر الأحمر', 'Frontier', 'الحدود', 'EG-BA', FALSE),
    (26, 'WAD', 'New Valley', 'الوادي الجديد', 'Frontier', 'الحدود', 'EG-WAD', FALSE),
    (27, 'MT', 'Matrouh', 'مطروح', 'Frontier', 'الحدود', 'EG-MT', FALSE);

INSERT INTO emop.source_vocabulary (
    source_vocabulary_id, vocabulary_code, vocabulary_name_en, vocabulary_name_ar, official_status
) VALUES
    (1, 'MOH_PROCEDURE', 'Example Ministry of Health procedures', 'مثال إجراءات وزارة الصحة', 'example_not_official'),
    (2, 'EG_DRUG', 'Example Egyptian drug list', 'مثال قائمة الدواء المصرية', 'example_not_official'),
    (3, 'ICD10_EG', 'Example bilingual ICD-10 labels', 'مثال تسميات ICD-10 بالعربي والإنجليزي', 'example_not_official'),
    (4, 'UHIA_SERVICE', 'Example UHIA service lines', 'مثال بنود خدمات التأمين الشامل', 'example_not_official');

INSERT INTO emop.source_code (
    source_code_id, source_vocabulary_id, source_code, code_name_en, code_name_ar,
    domain_id, valid_start_date, valid_end_date, example_not_official
) VALUES
    (1, 1, 'EX-MOH-PROC-001', 'Outpatient surgical consultation', 'استشارة جراحية خارجية', 'Procedure', DATE '2026-01-01', NULL, TRUE),
    (2, 1, 'EX-MOH-PROC-002', 'Haemoglobin laboratory test', 'تحليل هيموغلوبين', 'Procedure', DATE '2026-01-01', NULL, TRUE),
    (3, 2, 'EX-EDRUG-001', 'Metformin 500 mg tablet', 'ميتفورمين 500 ملغ قرص', 'Drug', DATE '2026-01-01', NULL, TRUE),
    (4, 2, 'EX-EDRUG-002', 'Amoxicillin 500 mg capsule', 'أموكسيسيلين 500 ملغ كبسولة', 'Drug', DATE '2026-01-01', NULL, TRUE),
    (5, 3, 'E11.9', 'Type 2 diabetes mellitus without complications', 'سكري النمط الثاني دون مضاعفات', 'Condition', DATE '2026-01-01', NULL, TRUE),
    (6, 3, 'I10', 'Essential (primary) hypertension', 'فرط ضغط الدم الأساسي', 'Condition', DATE '2026-01-01', NULL, TRUE),
    (7, 4, 'EX-UHIA-OPD-001', 'Outpatient visit', 'زيارة عيادات خارجية', 'Observation', DATE '2026-01-01', NULL, TRUE);

INSERT INTO emop.source_code_omop_map (
    source_code_id, concept_id, relationship_id, valid_start_date, valid_end_date
) VALUES
    (1, 2000001101, 'Maps to', DATE '2026-01-01', NULL),
    (2, 2000001102, 'Maps to', DATE '2026-01-01', NULL),
    (3, 2000001001, 'Maps to', DATE '2026-01-01', NULL),
    (4, 2000001002, 'Maps to', DATE '2026-01-01', NULL),
    (5, 2000001201, 'Maps to', DATE '2026-01-01', NULL),
    (6, 2000001202, 'Maps to', DATE '2026-01-01', NULL),
    (7, 2000001301, 'Maps to', DATE '2026-01-01', NULL);

INSERT INTO emop.source_to_concept_map (
    source_code, source_concept_id, source_vocabulary_id, source_code_description,
    target_concept_id, target_vocabulary_id, valid_start_date, valid_end_date, invalid_reason
) VALUES
    ('EX-MOH-PROC-001', 0, 'EMOP Example', 'Outpatient surgical consultation', 2000001101, 'EMOP Example', DATE '2026-01-01', DATE '2099-12-31', NULL),
    ('EX-EDRUG-001', 0, 'EMOP Example', 'Metformin 500 mg tablet', 2000001001, 'EMOP Example', DATE '2026-01-01', DATE '2099-12-31', NULL),
    ('E11.9', 0, 'EMOP Example', 'Type 2 diabetes mellitus without complications', 2000001201, 'EMOP Example', DATE '2026-01-01', DATE '2099-12-31', NULL);
