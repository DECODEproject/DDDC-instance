# This migration comes from decidim_petitions (originally 20190321112459)
class AddJsonAttributeInfoOptionalToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :json_attribute_info_optional, :jsonb
  end
end
