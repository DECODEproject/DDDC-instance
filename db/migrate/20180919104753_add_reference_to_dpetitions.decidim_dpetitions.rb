# frozen_string_literal: true
# This migration comes from decidim_dpetitions (originally 20180119150434)

class AddReferenceToDpetitions < ActiveRecord::Migration[5.1]
  class Dpetition < ApplicationRecord
    self.table_name = :decidim_dpetitions_dpetitions
  end

  def change
    add_column :decidim_dpetitions_dpetitions, :reference, :string
    Dpetition.find_each(&:touch)
  end
end
