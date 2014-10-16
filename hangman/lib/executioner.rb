require_relative './player'

class Executioner < Player
  
  attr_accessor :word
  
  def choose_word
    @word = @dictionary.sample
    @word.length
  end
  
  def evaluate_guess(guess)
    return {} unless @word.include?(guess)
    
    hash = Hash.new([])
    guess.split("").uniq.each do |letter|
      @word.split("").each_with_index  do 
        |el, i| hash[letter] += [i] if letter == el
      end
    end
    
    hash
  end
end