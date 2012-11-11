class RenameTwilioToTwilioNumber < ActiveRecord::Migration
  def up
    rename_table :twilios, :twilio_numbers
  end

  def down
  end
end
