# frozen_string_literal: true
# This migration comes from decidim_petitions (originally 20191017145054)

class AddDecodeStatusToPetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_petitions_petitions, :status, :jsonb, default: {
      credential_issuer: false,
      barcelona_now_dashboard: false,
      create_petition: false
    }
  end
end
