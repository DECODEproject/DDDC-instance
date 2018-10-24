# This migration comes from decidim_petitions (originally 20181024075203)
class MakePetitionAuthorsPolymorphic < ActiveRecord::Migration[5.2]
  class Petition < ApplicationRecord
    self.table_name = :decidim_petitions_petitions
  end
  def change
    remove_index :decidim_petitions_petitions, :decidim_author_id
    add_column :decidim_petitions_petitions, :decidim_author_type, :string

    reversible do |direction|
      direction.up do
        execute <<~SQL.squish
          UPDATE decidim_petitions_petitions
          SET decidim_author_type = 'Decidim::UserBaseEntity'
        SQL
      end
    end

    add_index :decidim_petitions_petitions,
              [:decidim_author_id, :decidim_author_type],
              name: "index_decidim_petitions_on_decidim_author"

    change_column_null :decidim_petitions_petitions, :decidim_author_id, false
    change_column_null :decidim_petitions_petitions, :decidim_author_type, false

    Petition.reset_column_information
  end
end
