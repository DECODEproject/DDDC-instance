# This migration comes from decidim_petitions (originally 20190313172108)
class AddJsonAttributeInfoToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :json_attribute_info, :jsonb
  end
end
