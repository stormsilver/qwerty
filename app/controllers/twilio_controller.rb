class TwilioController < ApplicationController
  
  def mvoice
    Rails.logger.ap(params)
  end

  def msms
    Rails.logger.ap(params)
    
  end
end
