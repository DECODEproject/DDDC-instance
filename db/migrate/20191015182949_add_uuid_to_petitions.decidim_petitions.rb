# frozen_string_literal: true
# This migration comes from decidim_petitions (originally 20190627170805)

class AddUuidToPetitions < ActiveRecord::Migration[5.2]
  def up
    enable_extension "uuid-ossp"
    enable_extension "pgcrypto"
    add_column :decidim_petitions_petitions, :uuid, :uuid, default: "gen_random_uuid()", null: false

    change_table :decidim_petitions_petitions do |t|
      t.remove :id
      t.rename :uuid, :id
    end

    execute "ALTER TABLE decidim_petitions_petitions ADD PRIMARY KEY (id)"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
