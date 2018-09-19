# frozen_string_literal: true
# This migration comes from decidim_dpetitions (originally 20180117100413)

class AddDpetitionInformationUpdates < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_dpetitions_dpetitions, :information_updates, :jsonb
  end
end
