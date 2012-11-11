class FooController < ApplicationController
  def index
    user = User.new :nickname => params[:nickname]
    text = Text.new :body => params[:body]
    text.user = user
    game = Game.find_match(user)
    provider = DungeonMaster::Master.provider_for game, user, text
    provider.run
    render :text => "foo"
  end
end
  