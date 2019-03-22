# This migration comes from decidim_petitions (originally 20190322182803)
class RemovePetitionBearerFromPetitions < ActiveRecord::Migration[5.2]
  def change
    remove_column :decidim_petitions_petitions, :petition_bearer, :string
  end
end
