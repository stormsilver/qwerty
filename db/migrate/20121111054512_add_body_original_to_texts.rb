class AddBodyOriginalToTexts < ActiveRecord::Migration
  def change
    add_column :texts, :body_original, :string
  end
end
