class AddStateToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :state, :string, default: "closed"
  end
end
