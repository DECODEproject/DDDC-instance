# frozen_string_literal: true

class AddDpetitionInformationUpdates < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_dpetitions_dpetitions, :information_updates, :jsonb
  end
end
