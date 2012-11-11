class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string :key
      t.float :value, :default => 0.0
      t.timestamps
    end
  end
end
