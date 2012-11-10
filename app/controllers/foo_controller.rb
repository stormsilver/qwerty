class FooController < ApplicationController
  def index
    user = User.new
    text = Text.new
    game = Game.find_match(user)
    DungeonMaster.provider_for game, user, text
    render :text => "foo"
  end
end
  