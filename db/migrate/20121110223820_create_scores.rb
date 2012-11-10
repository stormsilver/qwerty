class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :amount
      t.integer :user_id
      t.integer :round_id
      t.timestamps
    end
  end
end
