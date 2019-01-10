class AddDefaultAuthorType < ActiveRecord::Migration[5.2]
  def change
    change_column_default :decidim_petitions_petitions, :decidim_author_type, "Decidim::User"
  end
end
