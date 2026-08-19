-- EMOP Egyptian extension tables, v0.1
-- Copyright 2026 Gehad Sayed Ahmed
-- Licensed under the Apache License, Version 2.0
--
-- These tables sit beside OMOP CDM 5.4 in schema emop. Core OMOP table
-- names are unchanged. Apply after 00_create_schema.sql, the OMOP 5.4 DDL,
-- and the OMOP 5.4 primary keys.

CREATE TABLE emop.emop_cdm_source (
    emop_cdm_source_name varchar(255) NOT NULL,
    emop_cdm_version varchar(32) NOT NULL,
    omop_cdm_version varchar(32) NOT NULL,
    emop_release_date date NOT NULL,
    comment varchar(1024) NULL
);

CREATE TABLE emop.governorate (
    governorate_id integer NOT NULL,
    governorate_code varchar(16) NOT NULL,
    governorate_name_en varchar(255) NOT NULL,
    governorate_name_ar varchar(255) NOT NULL,
    region_name_en varchar(255) NULL,
    region_name_ar varchar(255) NULL,
    location_id integer NULL,
    iso_3166_2 varchar(16) NULL,
    example_not_official boolean NOT NULL DEFAULT FALSE,
    CONSTRAINT xpk_governorate PRIMARY KEY (governorate_id),
    CONSTRAINT uq_governorate_code UNIQUE (governorate_code),
    CONSTRAINT fpk_governorate_location FOREIGN KEY (location_id) REFERENCES emop.location (location_id)
);

CREATE TABLE emop.national_identifier (
    national_identifier_id integer NOT NULL,
    person_id integer NOT NULL,
    identifier_type varchar(64) NOT NULL,
    identifier_type_concept_id integer NULL,
    identifier_source_value varchar(128) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NULL,
    example_not_official boolean NOT NULL DEFAULT TRUE,
    CONSTRAINT xpk_national_identifier PRIMARY KEY (national_identifier_id),
    CONSTRAINT fpk_nid_person FOREIGN KEY (person_id) REFERENCES emop.person (person_id)
);

CREATE TABLE emop.facility_extension (
    care_site_id integer NOT NULL,
    moh_facility_code varchar(64) NULL,
    facility_sector varchar(32) NOT NULL,
    governorate_id integer NULL,
    urban_rural varchar(16) NULL,
    teaching_facility_flag integer NOT NULL DEFAULT 0,
    example_not_official boolean NOT NULL DEFAULT TRUE,
    CONSTRAINT xpk_facility_extension PRIMARY KEY (care_site_id),
    CONSTRAINT fpk_facext_care_site FOREIGN KEY (care_site_id) REFERENCES emop.care_site (care_site_id),
    CONSTRAINT fpk_facext_gov FOREIGN KEY (governorate_id) REFERENCES emop.governorate (governorate_id)
);

CREATE TABLE emop.insurance_scheme (
    insurance_scheme_id integer NOT NULL,
    scheme_code varchar(32) NOT NULL,
    scheme_name_en varchar(255) NOT NULL,
    scheme_name_ar varchar(255) NOT NULL,
    scheme_type varchar(32) NOT NULL,
    example_not_official boolean NOT NULL DEFAULT TRUE,
    CONSTRAINT xpk_insurance_scheme PRIMARY KEY (insurance_scheme_id),
    CONSTRAINT uq_insurance_scheme_code UNIQUE (scheme_code)
);

CREATE TABLE emop.person_insurance (
    person_insurance_id integer NOT NULL,
    person_id integer NOT NULL,
    insurance_scheme_id integer NOT NULL,
    coverage_start_date date NOT NULL,
    coverage_end_date date NULL,
    subscriber_source_value varchar(128) NULL,
    example_not_official boolean NOT NULL DEFAULT TRUE,
    CONSTRAINT xpk_person_insurance PRIMARY KEY (person_insurance_id),
    CONSTRAINT fpk_pins_person FOREIGN KEY (person_id) REFERENCES emop.person (person_id),
    CONSTRAINT fpk_pins_scheme FOREIGN KEY (insurance_scheme_id) REFERENCES emop.insurance_scheme (insurance_scheme_id)
);

CREATE TABLE emop.care_sector (
    care_sector_id integer NOT NULL,
    sector_code varchar(32) NOT NULL,
    sector_name_en varchar(255) NOT NULL,
    sector_name_ar varchar(255) NOT NULL,
    CONSTRAINT xpk_care_sector PRIMARY KEY (care_sector_id),
    CONSTRAINT uq_care_sector_code UNIQUE (sector_code)
);

CREATE TABLE emop.referral (
    referral_id integer NOT NULL,
    person_id integer NOT NULL,
    from_care_site_id integer NULL,
    to_care_site_id integer NULL,
    referring_visit_occurrence_id integer NULL,
    referral_date date NOT NULL,
    referral_priority varchar(32) NULL,
    referral_reason_source_value varchar(255) NULL,
    referral_reason_concept_id integer NULL,
    example_not_official boolean NOT NULL DEFAULT TRUE,
    CONSTRAINT xpk_referral PRIMARY KEY (referral_id),
    CONSTRAINT fpk_ref_person FOREIGN KEY (person_id) REFERENCES emop.person (person_id),
    CONSTRAINT fpk_ref_from FOREIGN KEY (from_care_site_id) REFERENCES emop.care_site (care_site_id),
    CONSTRAINT fpk_ref_to FOREIGN KEY (to_care_site_id) REFERENCES emop.care_site (care_site_id),
    CONSTRAINT fpk_ref_visit FOREIGN KEY (referring_visit_occurrence_id) REFERENCES emop.visit_occurrence (visit_occurrence_id)
);

CREATE TABLE emop.visit_care_context (
    visit_occurrence_id integer NOT NULL,
    care_sector_id integer NULL,
    insurance_scheme_id integer NULL,
    referral_id integer NULL,
    emergency_flag integer NOT NULL DEFAULT 0,
    example_not_official boolean NOT NULL DEFAULT TRUE,
    CONSTRAINT xpk_visit_care_context PRIMARY KEY (visit_occurrence_id),
    CONSTRAINT fpk_vcc_visit FOREIGN KEY (visit_occurrence_id) REFERENCES emop.visit_occurrence (visit_occurrence_id),
    CONSTRAINT fpk_vcc_sector FOREIGN KEY (care_sector_id) REFERENCES emop.care_sector (care_sector_id),
    CONSTRAINT fpk_vcc_scheme FOREIGN KEY (insurance_scheme_id) REFERENCES emop.insurance_scheme (insurance_scheme_id),
    CONSTRAINT fpk_vcc_referral FOREIGN KEY (referral_id) REFERENCES emop.referral (referral_id)
);

CREATE TABLE emop.person_name_bilingual (
    person_id integer NOT NULL,
    given_name_en varchar(255) NULL,
    family_name_en varchar(255) NULL,
    given_name_ar varchar(255) NULL,
    family_name_ar varchar(255) NULL,
    preferred_language varchar(8) NOT NULL DEFAULT 'ar',
    CONSTRAINT xpk_person_name_bilingual PRIMARY KEY (person_id),
    CONSTRAINT fpk_pnb_person FOREIGN KEY (person_id) REFERENCES emop.person (person_id)
);

CREATE TABLE emop.source_vocabulary (
    source_vocabulary_id integer NOT NULL,
    vocabulary_code varchar(64) NOT NULL,
    vocabulary_name_en varchar(255) NOT NULL,
    vocabulary_name_ar varchar(255) NOT NULL,
    official_status varchar(64) NOT NULL DEFAULT 'example_not_official',
    CONSTRAINT xpk_source_vocabulary PRIMARY KEY (source_vocabulary_id),
    CONSTRAINT uq_source_vocabulary_code UNIQUE (vocabulary_code)
);

CREATE TABLE emop.source_code (
    source_code_id integer NOT NULL,
    source_vocabulary_id integer NOT NULL,
    source_code varchar(64) NOT NULL,
    code_name_en varchar(512) NOT NULL,
    code_name_ar varchar(512) NOT NULL,
    domain_id varchar(32) NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NULL,
    example_not_official boolean NOT NULL DEFAULT TRUE,
    CONSTRAINT xpk_source_code PRIMARY KEY (source_code_id),
    CONSTRAINT fpk_sc_vocab FOREIGN KEY (source_vocabulary_id) REFERENCES emop.source_vocabulary (source_vocabulary_id)
);

CREATE TABLE emop.source_code_omop_map (
    source_code_id integer NOT NULL,
    concept_id integer NOT NULL,
    relationship_id varchar(20) NOT NULL DEFAULT 'Maps to',
    valid_start_date date NOT NULL,
    valid_end_date date NULL,
    CONSTRAINT xpk_source_code_omop_map PRIMARY KEY (source_code_id, concept_id, relationship_id),
    CONSTRAINT fpk_scom_code FOREIGN KEY (source_code_id) REFERENCES emop.source_code (source_code_id),
    CONSTRAINT fpk_scom_concept FOREIGN KEY (concept_id) REFERENCES emop.concept (concept_id)
);

CREATE INDEX idx_nid_person ON emop.national_identifier (person_id);
CREATE INDEX idx_facext_gov ON emop.facility_extension (governorate_id);
CREATE INDEX idx_pins_person ON emop.person_insurance (person_id);
CREATE INDEX idx_referral_person ON emop.referral (person_id);
CREATE INDEX idx_source_code_vocab ON emop.source_code (source_vocabulary_id, source_code);
CREATE INDEX idx_scom_concept ON emop.source_code_omop_map (concept_id);
