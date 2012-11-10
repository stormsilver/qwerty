class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone_number
      t.string :nickname
      t.integer :area_code
      t.timestamps
    end
  end
end
