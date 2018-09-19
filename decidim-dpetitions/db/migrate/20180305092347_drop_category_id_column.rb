# frozen_string_literal: true

class DropCategoryIdColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :decidim_dpetitions_dpetitions, :decidim_category_id
  end
end
