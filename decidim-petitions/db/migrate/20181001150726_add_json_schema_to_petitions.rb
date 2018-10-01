class AddJsonSchemaToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :json_schema, :jsonb
  end
end
