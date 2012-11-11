class Text < ActiveRecord::Base
  belongs_to :round
  belongs_to :game
  belongs_to :user

  before_save do
    self.body = self.body.strip.downcase
  end

  def self.main_rx(from, to, body)
    user = User.find_or_create(from)
    sms = self.create(
      :body => body,
      :user => user
    )
    case sms.body
    when "start"
      game = Game.find_waiting_or_start(user)
      if game
        provider = DungeonMaster::Master.provider_for game, user, sms
        provider.run
      end
    when "nick"
      tmp = body.split(" ")
      tmp.shift
      user.nickname = tmp.join(" ")[0,16]
      user.save
      TwilioNumber.send_message("You will now be known as #{user.nickname}", user)
    else
      TwilioNumber.send_message("You do not have an active game for this number", user)
    end
  end

  def self.game_rx(from, to, body)
    user = User.find_or_create(from)
    game = Game.find_active(user, to)
    sms = self.create(
      :body => body,
      :user => user,
      :game => game
    )

    if game
      provider = DungeonMaster::Master.provider_for game, user, sms
      provider.run
    end
  end

end
