# frozen_string_literal: true

class Group
  def self.LONE_ARRANGER_GROUP_CODE
    "lone-arranger"
  end
end

class Repository < Sequel::Model(:repository)
  # after_save not used by ASpace
  def after_save
    super

    create_lone_arranger_group
  end

  def create_lone_arranger_group
    RequestContext.open(repo_id: self.id) do
      Group.create_from_json(
        JSONModel(:group).from_hash(Repository.lone_arranger_group),
        repo_id: self.id
      )
    end
  end

  def self.lone_arranger_group
    {
      group_code: Group.LONE_ARRANGER_GROUP_CODE,
      description: "Lone Arrangers",
      grants_permissions: lone_arranger_group_permissions
    }
  end

  def self.lone_arranger_group_permissions
    [
      "view_repository",
    ]
  end
end
