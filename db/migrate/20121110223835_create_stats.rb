class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string :key
      t.float :value
      t.timestamps
    end
  end
end
