class AddColumnQueueTimeToUser < ActiveRecord::Migration
  def change
  	add_column :users, :queue_time, :datetime
  	add_index :users, :queue_time
  end
end
