# frozen_string_literal: true
# This migration comes from decidim_petitions (originally 20190623032708)

class AddUserGroupIdToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :decidim_user_group_id, :integer
  end
end
