class TwilioController < ApplicationController
  
  def main_voice
    Rails.logger.ap(params)
  end

  def main_sms
    Text.main_rx(params[:From], params[:To], params[:Body])
  end

  def game_voice
    Rails.logger.ap(params)
  end

  def game_sms
    Text.game_rx(params[:From], params[:To], params[:Body])
  end
end
