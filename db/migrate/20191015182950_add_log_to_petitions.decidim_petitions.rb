# frozen_string_literal: true
# This migration comes from decidim_petitions (originally 20191015162259)

class AddLogToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :log, :text
  end
end
