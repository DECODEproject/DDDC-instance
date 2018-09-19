# frozen_string_literal: true

class AddAuthorToDpetitions < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_dpetitions_dpetitions, :decidim_author_id, :integer
  end
end
