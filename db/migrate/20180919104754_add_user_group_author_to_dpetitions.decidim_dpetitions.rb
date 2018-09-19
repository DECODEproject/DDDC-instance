# frozen_string_literal: true
# This migration comes from decidim_dpetitions (originally 20180122090505)

class AddUserGroupAuthorToDpetitions < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_dpetitions_dpetitions, :decidim_user_group_id, :integer
  end
end
