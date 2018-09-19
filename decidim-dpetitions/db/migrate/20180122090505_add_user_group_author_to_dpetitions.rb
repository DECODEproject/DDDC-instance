# frozen_string_literal: true

class AddUserGroupAuthorToDpetitions < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_dpetitions_dpetitions, :decidim_user_group_id, :integer
  end
end
