class TwilioNumber < ActiveRecord::Base
  def self.send_message(message, user, game=nil, phone_override=nil)
    phone = ApplicationConfig[:twilio_main_phone]
    if phone_override
      phone = phone_override
    elsif game
      phone = game.phone_number
    end
    
    truncated_message = message[0, 160]
    Rails.logger.ap("****** Sending Twilio message to #{user.nickname} (#{user.phone_number}), from (#{phone}): #{truncated_message}")
    
    if Rails.env.production? || user.phone_number == "+18162132421"
      @twilio_client = Twilio::REST::Client.new ApplicationConfig[:twilio_account], ApplicationConfig[:twilio_token]
      @twilio_client.account.sms.messages.create(
        :from => phone,
        :to => user.phone_number,
        :body => truncated_message
      )
    end
  end
end
