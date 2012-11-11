class Twilio < ActiveRecord::Base

  def self.send_message(message, user)
    Rails.logger.debug("Sending Twilio message to #{user.nickname} (#{user.phone_number}): #{message}")
  end
end
