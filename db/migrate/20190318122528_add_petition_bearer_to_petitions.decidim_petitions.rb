# This migration comes from decidim_petitions (originally 20190318122403)
class AddPetitionBearerToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :petition_bearer, :string
  end
end
