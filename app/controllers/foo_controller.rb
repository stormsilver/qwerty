class FooController < ApplicationController
  def index
    
  end

  def event
    Pusher['qwerty'].trigger('games-count', {:count => 1000})
    render :text => ""
  end
end
  