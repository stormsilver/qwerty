class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.string :body
      t.integer :user_id
      t.integer :round_id
      t.integer :game_id
      t.timestamps
    end
  end
end
