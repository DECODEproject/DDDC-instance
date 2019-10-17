# frozen_string_literal: true
# This migration comes from decidim_petitions (originally 20191017143904)

class ChangeIdToPetitions < ActiveRecord::Migration[5.2]
  def up
    change_table :decidim_petitions_petitions do |t|
      t.remove :id
    end

    add_column :decidim_petitions_petitions, :id, :primary_key
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
