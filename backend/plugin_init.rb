# frozen_string_literal: true

require_relative '../lib/lone_arranger.rb'

ArchivesSpaceService.loaded_hook do
  Repository.each do |repo|
    # WARNING: we don't want to pullute the global repo
    next if repo.id == Repository.global_repo_id

    la_grp = Group.where(repo_id: repo.id).find do |g|
      g.group_code == Group.LONE_ARRANGER_GROUP_CODE
    end

    # Create or enforce Lone Arranger group permissions
    if la_grp.nil?
      Log.debug("Creating Lone Arranger group (#{repo.repo_code})")
      la_grp = repo.create_lone_arranger_group
    else
      Log.debug("Enforcing Lone Arranger group permissions (#{repo.repo_code})")
      Group.set_permissions(
        la_grp,
        OpenStruct.new(grants_permissions: Repository.lone_arranger_group_permissions)
      )
    end

    # Iterate through the non-LA groups and collect usernames
    users = []
    other_groups = Group.where(repo_id: repo.id).find_all do |g|
      g.group_code != Group.LONE_ARRANGER_GROUP_CODE
    end

    other_groups.each do |group|
      users.concat(group.user.map { |member| member[:username] })
    end

    if users.any?
      Log.debug("Adding users to Lone Arranger group (#{repo.repo_code}): #{users.uniq.inspect}")
      Group.set_members(la_grp, OpenStruct.new(member_usernames: users.uniq))

      # Lastly, after LA reassignment, clear out the other groups
      other_groups.each { |g| Group.set_members(g, OpenStruct.new(member_usernames: [])) }
    end
  end
end
