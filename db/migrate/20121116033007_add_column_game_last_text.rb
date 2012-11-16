class AddColumnGameLastText < ActiveRecord::Migration
  def change
    add_column :games, :last_text, :string
  end
end
