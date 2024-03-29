# frozen_string_literal: true

class Group
  def self.LONE_ARRANGER_GROUP_CODE
    "lone-arranger"
  end
end

class Repository < Sequel::Model(:repository)
  # after_save not used by ASpace
  # We need this for new repositories created via the UI
  def after_save
    super

    create_lone_arranger_group if lone_arranger_group.nil?
  end

  # Create lone arranger group for this repo
  def create_lone_arranger_group
    RequestContext.open(repo_id: id) do
      Group.create_from_json(
        JSONModel(:group).from_hash(Repository.lone_arranger_group),
        repo_id: id
      )
    end
  end

  # Fetch lone arranger group for this repo (nil if not found)
  def lone_arranger_group
    Group.where(repo_id: id).find do |g|
      g.group_code == Group.LONE_ARRANGER_GROUP_CODE
    end
  end

  # Lone arranger group specification
  def self.lone_arranger_group
    {
      group_code: Group.LONE_ARRANGER_GROUP_CODE,
      description: "Lone Arrangers",
      grants_permissions: lone_arranger_group_permissions
    }
  end

  # Lone arranger group permissions
  def self.lone_arranger_group_permissions
    [
      "cancel_importer_job",
      "cancel_job",
      "create_job",
      "delete_archival_record",
      "delete_assessment_record",
      "delete_classification_record",
      "delete_event_record",
      "import_records",
      "manage_agent_record",
      "manage_assessment_attributes",
      "manage_container_profile_record",
      "manage_container_record",
      "manage_custom_report_templates",
      "manage_enumeration_record",
      "manage_location_profile_record",
      "manage_rde_templates",
      "manage_repository",
      "manage_subject_record",
      "manage_vocabulary_record",
      "merge_agents_and_subjects",
      "merge_archival_record",
      "suppress_archival_record",
      "update_accession_record",
      "update_assessment_record",
      "update_classification_record",
      "update_container_record",
      "update_digital_object_record",
      "update_event_record",
      "update_resource_record",
      "view_agent_contact_record",
      "view_repository",
      "view_suppressed",
    ]
  end
end
