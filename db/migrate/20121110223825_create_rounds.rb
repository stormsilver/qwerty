class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :kind
      t.integer :game_id
      t.text :data
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
    end
  end
end
