class StatisticsController < ApplicationController
  def index
    data = {}
    PushMaster.statistics.each do |key, proc|
      data[key] = proc.call
    end
    render :json => data, :callback => params[:callback]
  end
end