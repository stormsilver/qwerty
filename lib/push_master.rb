class PushMaster
  def self.push(key, data)
    Rails.logger.info("PUSHER: #{key} - #{data.inspect}")
    Pusher['qwerty'].trigger(key, data)
  end
end