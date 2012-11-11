class AddActiveToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :active, :boolean, :default => false
  end
end
