class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :phone_number
      t.boolean :active
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
    end
  end
end
