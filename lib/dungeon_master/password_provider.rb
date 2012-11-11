module DungeonMaster
  class PasswordProvider < Master
    def self.get_password
      "chair"
    end
    
    
    def run
      if @game.users.count < 2
        # waiting for more players
        TwilioNumber.send_message("Waiting for another player to join.", user)
        return
      end
      
      if @round.data.empty?
        # new game
        @game.start_time = Time.now
        @game.active = true

        @round.start_time = Time.now
        @round.active = true
        @round.data[:password] = self.class.get_password
        @round.data[:points] = 5
        
        # pick a clue giver
        @round.data[:clue_giver] = @game.users.first
        TwilioNumber.send_message("The password is: #{@round.data[:password]}. Give your clue, 'skip' to get a new word, or 'stop' to end.", @round.data[:clue_giver])
        
        # other one is the guesser
        @round.data[:guesser] = @game.users.last
        TwilioNumber.send_message("You are guessing the password. #{@round.data[:clue_giver].nickname} is thinking of a clue. 'stop' to end.", @round.data[:guesser])
        
        @game.save
        @round.save
      else
        case @text.body
        when 'skip'
          
        else
          # TODO: handle chat
          if @user == @round.data[:clue_giver]
            TwilioNumber.send_message("#{@user.nickname}'s clue is: #{@text.body}. Your turn to guess.")
          elsif @user == @round.data[:guesser]
            if @text.body == @round.data[:password]
              message = "Correct! You each get #{@round.data[:points]} points."
            else
              @round.data[:points] -= 1
              message = "Incorrect. Give another clue for #{points} points."
            end
            TwilioNumber.send_message("#{@user.nickname}'s guess is: #{@text.body}.")
          end
        end
      end

    end
  end
end