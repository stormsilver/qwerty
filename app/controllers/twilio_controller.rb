class TwilioController < ApplicationController
  
  def main_voice
    Rails.logger.ap(params)
  end

  def main_sms
    Rails.logger.ap(params)
    
  end

  def game_voice
    Rails.logger.ap(params)
  end

  def game_sms
    Rails.logger.ap(params)
    
  end
end
