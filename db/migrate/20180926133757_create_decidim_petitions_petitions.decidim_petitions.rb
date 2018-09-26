# This migration comes from decidim_petitions (originally 20180919160655)
class CreateDecidimPetitionsPetitions < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_petitions_petitions do |t|
      t.jsonb :title
      t.jsonb :summary
      t.jsonb :description
      t.boolean :open, default: false
      t.references :decidim_organization,
                   foreign_key: true,
                   index: { name: "index_decidim_petition_on_decidim_organization_id" }
      t.integer :decidim_author_id,
                index: true
      t.references :decidim_component, index: true
      t.datetime :published_at, index: true
      t.timestamps
    end
  end
end
