require_relative './executioner'
require_relative './guesser'
require 'debugger'

class Hangman
  def run(executioner, guesser, turns)
    @total_turns = turns
    @executioner = executioner
    @guesser = guesser
    
    word_length = executioner.choose_word
    
    @word_so_far = Array.new(word_length) { nil }
    @turns_so_far = 0
    @total_turns = turns
    
    until over?
      @turns_so_far += 1
      turns_left = @total_turns - @turns_so_far
      guess = guesser.get_guess(@word_so_far, turns_left)
      @final_guess = guess.length > 1
      update_hash = executioner.evaluate_guess(guess)
      update_word_so_far(update_hash)
     
    end
    
    puts "#{winner.name} is the winner!"
    puts winner.word if winner == @executioner
  end
  
  def over?
    @final_guess || !@word_so_far.include?(nil) || @turns_so_far >= @total_turns
  end
  
  def update_word_so_far(hash)
    hash.each do |letter, positions| 
      positions.each { |position| @word_so_far[position] = letter }  
    end
  end
  
  def winner
    return nil unless over?
    if @word_so_far.include?(nil)
      @executioner
    else
      @guesser
    end
  end
end