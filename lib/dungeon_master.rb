class DungeonMaster
  def self.provider_for(game, user, text)
    # find active round
    round = game.active_round
    unless round
      round = game.rounds.create :kind => 'password', :
    end
    "DungeonMaster::#{round.kind.capitalize}Provider".constantize.new(game, round, user, text)
  end
  
  attr :game, :round, :user, :text
  
  def initialize(game, round, user, text)
    @game = game
    @round = round
    @user = user
    @text = text
  end
  
  def run
    throw NotImplementedError
  end
end