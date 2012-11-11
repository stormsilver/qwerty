module DungeonMaster
  class PasswordProvider < Master
    MAX_POINTS = 5
    
    
    def self.get_password
      words = Rails.cache.fetch("wordslist", :expires_in => 1.hour) do
        IO.readlines(File.join(Rails.root, 'db', 'words.txt'))
      end
      words.sample.strip
    end
    
    
    def run
      if @game.users.count < 2
        # waiting for more players
        TwilioNumber.send_message("Waiting for another player to join.", user, @game)
        return
      end
      
      if @round.data.empty?
        # new game
        initialize_round(@game.users.first, @game.users.last)
        @game.start
        @text.round = @round
      else
        handled = false
        @text.round = @round
        
        if @user == @round.data[:clue_giver]
          other_user = @round.data[:guesser]
        else
          other_user = @round.data[:clue_giver]
        end
        
        case @text.body
        when 'skip'
          # only allow one skip
          if @round.active && @user == @round.data[:clue_giver] && @round.data[:points] == MAX_POINTS
            if @round.data[:skips] < 1
              @round.data[:skips] += 1
              @round.data[:password] = self.class.get_password
              TwilioNumber.send_message("Fine. The new password is: #{@round.data[:password]}. Give your clue. No more skips.", @round.data[:clue_giver], @game)
            else
              TwilioNumber.send_message("Only one skip, bro. Your password is still #{@round.data[:password]}.", @round.data[:clue_giver], @game)
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
        when 'done'
          TwilioNumber.send_message("#{@user.nickname} has ended the game.", other_user, @game)
          @round.stop
          @game.stop
          handled = true         
        end
        
        
        if !handled
          if @round.active
            if @user != @round.data[:turn]
              TwilioNumber.send_message("It's not your turn. Be patient.", @user, @game)
            else
              if @user == @round.data[:clue_giver]
                if password_matched?
                  TwilioNumber.send_message("That's the password, silly. Send a real clue this time.", @round.data[:clue_giver], @game)
                else
                  TwilioNumber.send_message("#{@user.nickname}'s clue is: #{@text.body_original}. Your turn to guess for #{@round.data[:points]} points.", @round.data[:guesser], @game)
                  @round.data[:turn] = @round.data[:guesser]
                end
              elsif @user == @round.data[:guesser]
                if password_matched?
                  log_scores
                  TwilioNumber.send_message("#{@user.nickname}'s guess is: #{@text.body_original}. Correct! You each get #{@round.data[:points]} points. PLAY again, DONE, or keep texting to just chat.", @round.data[:clue_giver], @game)
                  TwilioNumber.send_message("Correct! You each get #{@round.data[:points]} points. PLAY again, DONE, or keep texting to just chat.", @round.data[:guesser], @game)
                  @round.stop
                else
                  @round.data[:points] -= 1
                  if @round.data[:points] < 1
                    # round over
                    log_scores
                    TwilioNumber.send_message("QWERTY wins! Your partner was unable to guess the password. 0 points. PLAY again, DONE, or keep texting to just chat.", @round.data[:clue_giver], @game)
                    TwilioNumber.send_message("QWERTY wins! Your partner was unable to give you the password. 0 points. PLAY again, DONE, or keep texting to just chat.", @round.data[:guesser], @game)
                    @round.stop
                  else
                    TwilioNumber.send_message("#{@user.nickname}'s guess is: #{@text.body_original}. Incorrect. Give another clue for #{@round.data[:points]} points.", @round.data[:clue_giver], @game)
                    @round.data[:turn] = @round.data[:clue_giver]
                  end
                end
              end
            end
          else
            # just chatting
            TwilioNumber.send_message("#{@user.nickname}: #{@text.body_original}", other_user, @game)
          end
        end
      end
      
      # just to be safe
      @text.save
      @round.save
      @game.save
      @game.users.each {|u| u.save}
    end
    
    def initialize_round(clue_giver, guesser)
      @round.data[:password] = self.class.get_password
      @round.data[:points] = MAX_POINTS
      @round.data[:skips] = 0
      @round.data[:turn] = clue_giver
        
      # pick a clue giver
      @round.data[:clue_giver] = clue_giver
      TwilioNumber.send_message("The password is: #{@round.data[:password]}. Give your clue, 'skip' to get a new word, or 'end' to end.", @round.data[:clue_giver], @game)
        
      # other one is the guesser
      @round.data[:guesser] = guesser
      TwilioNumber.send_message("You are guessing the password. #{@round.data[:clue_giver].nickname} is thinking of a clue. 'end' to end.", @round.data[:guesser], @game)
      
      @round.start
    end
    
    def log_scores
      @round.scores.create(:amount => @round.data[:points], :user => @round.data[:guesser])
      @round.scores.create(:amount => @round.data[:points], :user => @round.data[:clue_giver])
      
      PushMaster.generate_and_push('average-score')
      PushMaster.generate_and_push('leaderboard')
      PushMaster.generate_and_push('leaderboard-ace')
      PushMaster.generate_and_push('leaderboard-king')
    end
    
    def password_matched?
      @text.body == @round.data[:password].downcase.strip
    end
  end
end