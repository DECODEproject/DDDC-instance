# frozen_string_literal: true
# This migration comes from decidim_dpetitions (originally 20180305133556)

class RenameFeaturesToComponentsAtDpetitions < ActiveRecord::Migration[5.1]
  def change
    rename_column :decidim_dpetitions_dpetitions, :decidim_feature_id, :decidim_component_id

    if index_name_exists?(:decidim_dpetitions_dpetitions, "index_decidim_dpetitions_dpetitions_on_decidim_feature_id")
      rename_index :decidim_dpetitions_dpetitions, "index_decidim_dpetitions_dpetitions_on_decidim_feature_id", "index_decidim_dpetitions_dpetitions_on_decidim_component_id"
    end
  end
end
