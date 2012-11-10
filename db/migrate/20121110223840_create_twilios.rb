class CreateTwilios < ActiveRecord::Migration
  def change
    create_table :twilios do |t|
      t.string :phone_number
      t.string :twid
      t.timestamps
    end
  end
end
