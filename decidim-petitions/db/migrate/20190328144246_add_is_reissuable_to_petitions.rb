class AddIsReissuableToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :is_reissuable, :boolean
  end
end
