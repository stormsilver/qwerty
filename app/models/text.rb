class Text < ActiveRecord::Base
  belongs_to :round
  belongs_to :game
  belongs_to :user

  before_save do
    self.body_original = self.body.strip
    self.body = self.body_original.downcase
  end
      
  after_create do
    PushMaster.generate_and_push('sms-count')
  end

  def self.main_rx(from, to, body)
    user, is_new = User.find_or_create(from)
    sms = self.create(
      :body => body,
      :user => user
    )

    Rails.logger.ap("First Word: #{sms.first_word}")
    Rails.logger.ap("Message: #{sms.second_word_on}")

    case sms.first_word
    when "start"
      is_new = user.queue
      player1, player2 = User.find_next_two_waiting_users

      if !player1 || !player2
        if is_new
          TwilioNumber.send_message("We are now looking for an opponent for you", user)
        end
      else
        player1.queue_time = nil
        player2.queue_time = nil
        player1.save
        player2.save
        game = Game.start_game(player1, player2)
        if !game
          return
        end
        provider = DungeonMaster::Master.provider_for game, user, sms
        provider.run
      end
    when "nick"
      if sms.second_word_on.empty?
        TwilioNumber.send_message("You are currently known as: #{user.nickname}.  Send 'NICK {new name}' to change nickname.", user)
        return
      end
      user.nickname = sms.second_word_on[0,16]
      user.save
      TwilioNumber.send_message("You will now be known as: #{user.nickname}", user)
    when "h"
      TwilioNumber.send_message(ApplicationConfig[:main_menu], user)
    when "score"
      score = user.get_total_score
      TwilioNumber.send_message("Your total score is: #{score.to_i} points", user)
    when "rules"
      TwilioNumber.send_message(ApplicationConfig[:rules], user)
    else
      if !is_new
        TwilioNumber.send_message("Unknown command. #{ApplicationConfig[:main_menu]}", user)
      end
    end
  end

  def self.game_rx(from, to, body)
    user, is_new = User.find_or_create(from)
    game = Game.find_active(user, to)
    sms = self.create(:body => body, :user => user, :game => game)

    if game
      provider = DungeonMaster::Master.provider_for game, user, sms
      provider.run
    end
  end

  def split_message
    return self.body_original.split(" ")
  end

  def first_word
    return split_message.shift.strip.downcase
  end

  def second_word_on
    tmp = split_message
    tmp.shift
    return tmp.join(" ")
  end

end
