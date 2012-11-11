class StatisticsController < ApplicationController
  def index
    data = {}
    PushMaster.statistics.each do |key, proc|
      data[key] = proc.call
    end
    render :json => data
  end
end