class AddWaitingToGames < ActiveRecord::Migration
  def change
    add_column :games, :waiting_for_players, :boolean, :default => true
  end
end
