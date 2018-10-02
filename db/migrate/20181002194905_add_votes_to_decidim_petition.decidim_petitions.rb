# This migration comes from decidim_petitions (originally 20181002191914)
class AddVotesToDecidimPetition < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :votes, :integer, default: 0
  end
end
