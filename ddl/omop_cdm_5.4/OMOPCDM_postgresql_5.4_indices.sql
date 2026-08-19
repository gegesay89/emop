-- Source: OHDSI/CommonDataModel v5.4.2 (Apache License 2.0)
-- https://github.com/OHDSI/CommonDataModel/tree/v5.4.2/inst/ddl/5.4/postgresql
-- Placeholder @cdmDatabaseSchema replaced with schema emop for the EMOP distribution.
-- Original OMOP CDM copyright: Observational Health Data Sciences and Informatics (OHDSI).

/*postgresql OMOP CDM Indices
  There are no unique indices created because it is assumed that the primary key constraints have been run prior to
  implementing indices.
*/
/************************
Standardized clinical data
************************/
CREATE INDEX idx_person_id  ON emop.person  (person_id ASC);
CLUSTER emop.person  USING idx_person_id ;
CREATE INDEX idx_gender ON emop.person (gender_concept_id ASC);
CREATE INDEX idx_observation_period_id_1  ON emop.observation_period  (person_id ASC);
CLUSTER emop.observation_period  USING idx_observation_period_id_1 ;
CREATE INDEX idx_visit_person_id_1  ON emop.visit_occurrence  (person_id ASC);
CLUSTER emop.visit_occurrence  USING idx_visit_person_id_1 ;
CREATE INDEX idx_visit_concept_id_1 ON emop.visit_occurrence (visit_concept_id ASC);
CREATE INDEX idx_visit_det_person_id_1  ON emop.visit_detail  (person_id ASC);
CLUSTER emop.visit_detail  USING idx_visit_det_person_id_1 ;
CREATE INDEX idx_visit_det_concept_id_1 ON emop.visit_detail (visit_detail_concept_id ASC);
CREATE INDEX idx_visit_det_occ_id ON emop.visit_detail (visit_occurrence_id ASC);
CREATE INDEX idx_condition_person_id_1  ON emop.condition_occurrence  (person_id ASC);
CLUSTER emop.condition_occurrence  USING idx_condition_person_id_1 ;
CREATE INDEX idx_condition_concept_id_1 ON emop.condition_occurrence (condition_concept_id ASC);
CREATE INDEX idx_condition_visit_id_1 ON emop.condition_occurrence (visit_occurrence_id ASC);
CREATE INDEX idx_drug_person_id_1  ON emop.drug_exposure  (person_id ASC);
CLUSTER emop.drug_exposure  USING idx_drug_person_id_1 ;
CREATE INDEX idx_drug_concept_id_1 ON emop.drug_exposure (drug_concept_id ASC);
CREATE INDEX idx_drug_visit_id_1 ON emop.drug_exposure (visit_occurrence_id ASC);
CREATE INDEX idx_procedure_person_id_1  ON emop.procedure_occurrence  (person_id ASC);
CLUSTER emop.procedure_occurrence  USING idx_procedure_person_id_1 ;
CREATE INDEX idx_procedure_concept_id_1 ON emop.procedure_occurrence (procedure_concept_id ASC);
CREATE INDEX idx_procedure_visit_id_1 ON emop.procedure_occurrence (visit_occurrence_id ASC);
CREATE INDEX idx_device_person_id_1  ON emop.device_exposure  (person_id ASC);
CLUSTER emop.device_exposure  USING idx_device_person_id_1 ;
CREATE INDEX idx_device_concept_id_1 ON emop.device_exposure (device_concept_id ASC);
CREATE INDEX idx_device_visit_id_1 ON emop.device_exposure (visit_occurrence_id ASC);
CREATE INDEX idx_measurement_person_id_1  ON emop.measurement  (person_id ASC);
CLUSTER emop.measurement  USING idx_measurement_person_id_1 ;
CREATE INDEX idx_measurement_concept_id_1 ON emop.measurement (measurement_concept_id ASC);
CREATE INDEX idx_measurement_visit_id_1 ON emop.measurement (visit_occurrence_id ASC);
CREATE INDEX idx_observation_person_id_1  ON emop.observation  (person_id ASC);
CLUSTER emop.observation  USING idx_observation_person_id_1 ;
CREATE INDEX idx_observation_concept_id_1 ON emop.observation (observation_concept_id ASC);
CREATE INDEX idx_observation_visit_id_1 ON emop.observation (visit_occurrence_id ASC);
CREATE INDEX idx_death_person_id_1  ON emop.death  (person_id ASC);
CLUSTER emop.death  USING idx_death_person_id_1 ;
CREATE INDEX idx_note_person_id_1  ON emop.note  (person_id ASC);
CLUSTER emop.note  USING idx_note_person_id_1 ;
CREATE INDEX idx_note_concept_id_1 ON emop.note (note_type_concept_id ASC);
CREATE INDEX idx_note_visit_id_1 ON emop.note (visit_occurrence_id ASC);
CREATE INDEX idx_note_nlp_note_id_1  ON emop.note_nlp  (note_id ASC);
CLUSTER emop.note_nlp  USING idx_note_nlp_note_id_1 ;
CREATE INDEX idx_note_nlp_concept_id_1 ON emop.note_nlp (note_nlp_concept_id ASC);
CREATE INDEX idx_specimen_person_id_1  ON emop.specimen  (person_id ASC);
CLUSTER emop.specimen  USING idx_specimen_person_id_1 ;
CREATE INDEX idx_specimen_concept_id_1 ON emop.specimen (specimen_concept_id ASC);
CREATE INDEX idx_fact_relationship_id1 ON emop.fact_relationship (domain_concept_id_1 ASC);
CREATE INDEX idx_fact_relationship_id2 ON emop.fact_relationship (domain_concept_id_2 ASC);
CREATE INDEX idx_fact_relationship_id3 ON emop.fact_relationship (relationship_concept_id ASC);
/************************
Standardized health system data
************************/
CREATE INDEX idx_location_id_1  ON emop.location  (location_id ASC);
CLUSTER emop.location  USING idx_location_id_1 ;
CREATE INDEX idx_care_site_id_1  ON emop.care_site  (care_site_id ASC);
CLUSTER emop.care_site  USING idx_care_site_id_1 ;
CREATE INDEX idx_provider_id_1  ON emop.provider  (provider_id ASC);
CLUSTER emop.provider  USING idx_provider_id_1 ;
/************************
Standardized health economics
************************/
CREATE INDEX idx_period_person_id_1  ON emop.payer_plan_period  (person_id ASC);
CLUSTER emop.payer_plan_period  USING idx_period_person_id_1 ;
CREATE INDEX idx_cost_event_id  ON emop.cost (cost_event_id ASC);
/************************
Standardized derived elements
************************/
CREATE INDEX idx_drug_era_person_id_1  ON emop.drug_era  (person_id ASC);
CLUSTER emop.drug_era  USING idx_drug_era_person_id_1 ;
CREATE INDEX idx_drug_era_concept_id_1 ON emop.drug_era (drug_concept_id ASC);
CREATE INDEX idx_dose_era_person_id_1  ON emop.dose_era  (person_id ASC);
CLUSTER emop.dose_era  USING idx_dose_era_person_id_1 ;
CREATE INDEX idx_dose_era_concept_id_1 ON emop.dose_era (drug_concept_id ASC);
CREATE INDEX idx_condition_era_person_id_1  ON emop.condition_era  (person_id ASC);
CLUSTER emop.condition_era  USING idx_condition_era_person_id_1 ;
CREATE INDEX idx_condition_era_concept_id_1 ON emop.condition_era (condition_concept_id ASC);
/**************************
Standardized meta-data
***************************/
CREATE INDEX idx_metadata_concept_id_1  ON emop.metadata  (metadata_concept_id ASC);
CLUSTER emop.metadata  USING idx_metadata_concept_id_1 ;
/**************************
Standardized vocabularies
***************************/
CREATE INDEX idx_concept_concept_id  ON emop.concept  (concept_id ASC);
CLUSTER emop.concept  USING idx_concept_concept_id ;
CREATE INDEX idx_concept_code ON emop.concept (concept_code ASC);
CREATE INDEX idx_concept_vocabluary_id ON emop.concept (vocabulary_id ASC);
CREATE INDEX idx_concept_domain_id ON emop.concept (domain_id ASC);
CREATE INDEX idx_concept_class_id ON emop.concept (concept_class_id ASC);
CREATE INDEX idx_vocabulary_vocabulary_id  ON emop.vocabulary  (vocabulary_id ASC);
CLUSTER emop.vocabulary  USING idx_vocabulary_vocabulary_id ;
CREATE INDEX idx_domain_domain_id  ON emop.domain  (domain_id ASC);
CLUSTER emop.domain  USING idx_domain_domain_id ;
CREATE INDEX idx_concept_class_class_id  ON emop.concept_class  (concept_class_id ASC);
CLUSTER emop.concept_class  USING idx_concept_class_class_id ;
CREATE INDEX idx_concept_relationship_id_1  ON emop.concept_relationship  (concept_id_1 ASC);
CLUSTER emop.concept_relationship  USING idx_concept_relationship_id_1 ;
CREATE INDEX idx_concept_relationship_id_2 ON emop.concept_relationship (concept_id_2 ASC);
CREATE INDEX idx_concept_relationship_id_3 ON emop.concept_relationship (relationship_id ASC);
CREATE INDEX idx_relationship_rel_id  ON emop.relationship  (relationship_id ASC);
CLUSTER emop.relationship  USING idx_relationship_rel_id ;
CREATE INDEX idx_concept_synonym_id  ON emop.concept_synonym  (concept_id ASC);
CLUSTER emop.concept_synonym  USING idx_concept_synonym_id ;
CREATE INDEX idx_concept_ancestor_id_1  ON emop.concept_ancestor  (ancestor_concept_id ASC);
CLUSTER emop.concept_ancestor  USING idx_concept_ancestor_id_1 ;
CREATE INDEX idx_concept_ancestor_id_2 ON emop.concept_ancestor (descendant_concept_id ASC);
CREATE INDEX idx_source_to_concept_map_3  ON emop.source_to_concept_map  (target_concept_id ASC);
CLUSTER emop.source_to_concept_map  USING idx_source_to_concept_map_3 ;
CREATE INDEX idx_source_to_concept_map_1 ON emop.source_to_concept_map (source_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_2 ON emop.source_to_concept_map (target_vocabulary_id ASC);
CREATE INDEX idx_source_to_concept_map_c ON emop.source_to_concept_map (source_code ASC);
CREATE INDEX idx_drug_strength_id_1  ON emop.drug_strength  (drug_concept_id ASC);
CLUSTER emop.drug_strength  USING idx_drug_strength_id_1 ;
CREATE INDEX idx_drug_strength_id_2 ON emop.drug_strength (ingredient_concept_id ASC);
--Additional v6.0 indices
--CREATE CLUSTERED INDEX idx_survey_person_id_1 ON emop.survey_conduct (person_id ASC);
--CREATE CLUSTERED INDEX idx_episode_person_id_1 ON emop.episode (person_id ASC);
--CREATE INDEX idx_episode_concept_id_1 ON emop.episode (episode_concept_id ASC);
--CREATE CLUSTERED INDEX idx_episode_event_id_1 ON emop.episode_event (episode_id ASC);
--CREATE INDEX idx_ee_field_concept_id_1 ON emop.episode_event (event_field_concept_id ASC);
