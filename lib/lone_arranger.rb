# frozen_string_literal: true

class Repository < Sequel::Model(:repository)
  # after_save not used by ASpace
  def after_save
    super

    RequestContext.open(repo_id: self.id) do
      Group.create_from_json(
        JSONModel(:group).from_hash(Repository.lone_arranger_group),
        repo_id: self.id
      )
    end
  end

  def self.lone_arranger_group
    {
      group_code: "lone-arranger",
      description: "Lone Arrangers",
      grants_permissions: [
        "view_repository",
      ]
    }
  end
end
