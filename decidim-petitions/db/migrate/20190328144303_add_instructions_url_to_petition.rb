class AddInstructionsUrlToPetition < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :instructions_url, :jsonb
  end
end
