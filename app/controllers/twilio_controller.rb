class TwilioController < ApplicationController
  
  def main_voice
    Rails.logger.ap(params)
  end

  def main_sms
    Rails.logger.ap(params)
    Text.main_rx(params[:From], params[:To], params[:Body])
  end

  def game_voice
    Rails.logger.ap(params)
  end

  def game_sms
    Text.game_rx(params[:From], params[:To], params[:Body])
  end

  def fake
    Rails.logger.ap(params);
    if params[:To] == ApplicationConfig['twilio_main_phone']
      Text.main_rx(params[:From], params[:To], params[:Body]) 
    else
      Text.game_rx(params[:From], params[:To], params[:Body])
    end
    Rails.logger.ap(params)
    render :text => "hi"
  end
end
