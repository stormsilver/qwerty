class FooController < ApplicationController
  def index
    user = User.new :nickname => params[:nickname]
    text = Text.new :body => params[:body]
    text.user = user
    game = Game.find_or_create(user)
    if game == false
      TwilioNumber.send_message("You are already waiting for a game.", user)
    else
      provider = DungeonMaster::Master.provider_for game, user, text
      provider.run
    end
    render :text => "foo"
  end
end
  