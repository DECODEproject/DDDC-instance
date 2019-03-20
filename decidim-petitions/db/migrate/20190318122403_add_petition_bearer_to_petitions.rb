class AddPetitionBearerToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :petition_bearer, :string
  end
end
