module DungeonMaster
  class PasswordProvider < Master
    MAX_POINTS = 5
    
    
    def self.get_password
      # TODO: password list
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
        initialize_round(@game.users.first, @game.users.last)
        @game.start
      else
        handled = false
        @text.round = @round
        
        case @text.body
        when 'skip'
          # only allow one skip
          if @round.active && @user == @round.data[:clue_giver] && @round.data[:points] == MAX_POINTS
            if @round.data[:skips] < 1
              @round.data[:skips] += 1
              @round.data[:password] = self.class.get_password
              TwilioNumber.send_message("Fine. The new password is #{@round.data[:password]}. Give your clue. No more skips.", @round.data[:clue_giver])
            else
              TwilioNumber.send_message("Only one skip, bro. Your password is still #{@round.data[:password]}.", @round.data[:clue_giver])
            end
            handled = true
          end
        when 'play'
          unless @round.active
            old_round = @round
            @round = @game.rounds.create :kind => 'password'
            initialize_round(old_round.data[:guesser], old_round.data[:clue_giver])
            handled = true
          end
        when 'stop'
          @round.end
          @game.end
          handled = true         
        end
        
        
        if !handled && @round.active
          # TODO: handle chat
          if @user == @round.data[:clue_giver]
            TwilioNumber.send_message("#{@user.nickname}'s clue is: #{@text.body}. Your turn to guess.")
          elsif @user == @round.data[:guesser]
            if @text.body == @round.data[:password]
              @round.scores.create(:amount => @round.data[:points], :user => @round.data[:guesser])
              @round.scores.create(:amount => @round.data[:points], :user => @round.data[:clue_giver])
              TwilioNumber.send_message("#{@user.nickname}'s guess is: #{@text.body}. Correct! You each get #{@round.data[:points]} points.", @round.data[:clue_giver])
              TwilioNumber.send_message("Correct! You each get #{@round.data[:points]} points. PLAY again, STOP, or keep texting to just chat.", @round.data[:guesser])
              @round.end
            else
              @round.data[:points] -= 1
              if @round.data[:points] < 1
              else
                TwilioNumber.send_message("#{@user.nickname}'s guess is: #{@text.body}. Incorrect. Give another clue for #{points} points.", @round.data[:clue_giver])
              end
            end
          end
        end
      end
      
      @text.save
      @round.save
      @game.save
    end
    
    def initialize_round(clue_giver, guesser)
      @round.data[:password] = self.class.get_password
      @round.data[:points] = MAX_POINTS
      @round.data[:skips] = 0
        
      # pick a clue giver
      @round.data[:clue_giver] = clue_giver
      TwilioNumber.send_message("The password is: #{@round.data[:password]}. Give your clue, 'skip' to get a new word, or 'stop' to end.", @round.data[:clue_giver])
        
      # other one is the guesser
      @round.data[:guesser] = guesser
      TwilioNumber.send_message("You are guessing the password. #{@round.data[:clue_giver].nickname} is thinking of a clue. 'stop' to end.", @round.data[:guesser])
      
      @round.start
    end
  end
end
