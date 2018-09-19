# frozen_string_literal: true

class AddReferenceToDpetitions < ActiveRecord::Migration[5.1]
  class Dpetition < ApplicationRecord
    self.table_name = :decidim_dpetitions_dpetitions
  end

  def change
    add_column :decidim_dpetitions_dpetitions, :reference, :string
    Dpetition.find_each(&:touch)
  end
end
