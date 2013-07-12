require 'section_registry'

##############################################################
# Register all the sections we will use in the web application
############################################################## 
sr = SectionRegistry.instance

sr.add_section('advance_directive', 'http://projecthdata.org/extension/advance_directive', 'Advance Directives') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::AdvanceDirectiveImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:advance_directive)
end
sr.add_section('allergies', 'http://projecthdata.org/extension/allergy', 'Allergies') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::AllergyImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:allergy)
end
sr.add_section('care_goals', 'http://projecthdata.org/extension/care-goal', 'Care Goals') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::CareGoalImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:care_goal)
end
sr.add_section('conditions', 'http://projecthdata.org/extension/condition', 'Conditions') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::ConditionImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:condition)
end
sr.add_section('encounters', 'http://projecthdata.org/extension/encounter', 'Encounters') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::EncounterImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:encounter)
end
sr.add_section('immunizations', 'http://projecthdata.org/extension/immunization', 'Immunizations') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::ImmunizationImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:immunization)
end
#sr.add_section('insurance_providers', 'http://projecthdata.org/extension/insurance_provider', 'Insurance Provider') do |importers, exporters|
  #importers['application/xml'] = HealthDataStandards::Import::GreenC32::InsuranceProviderImporter.instance
  #exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:insurance_provider)
#end
sr.add_section('medical_equipment', 'http://projecthdata.org/extension/medical-equipment', 'Medical Equipment') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::MedicalEquipmentImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:medical_equipment)
end
sr.add_section('medications', 'http://projecthdata.org/extension/medication', 'Medications') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::MedicationImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:medication)
end
sr.add_section('procedures', 'http://projecthdata.org/extension/procedure', 'Procedures') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::ProcedureImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:procedure)
end
sr.add_section('results', 'http://projecthdata.org/extension/result', 'Lab Results') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::ResultImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:result)
end
sr.add_section('social_history', 'http://projecthdata.org/extension/social-history', 'Social History') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::SocialHistoryImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:social_history)
end
sr.add_section('vital_signs', 'http://projecthdata.org/extension/vital-sign', 'Vital Signs') do |importers, exporters|
  importers['application/xml'] = HealthDataStandards::Import::GreenC32::VitalSignImporter.instance
  exporters['application/xml'] = HealthDataStandards::Export::GreenC32::ExportGenerator.create_exporter_for(:vital_sign)
end
