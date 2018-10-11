# This migration comes from decidim_petitions (originally 20181010073653)
class AddImageToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :image, :string
  end
end
