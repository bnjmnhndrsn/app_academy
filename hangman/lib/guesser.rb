require_relative './player'

class Guesser < Player
  
  def get_guess(word_so_far, turns_so_far)
    p word_so_far, turns_so_far
    puts "guess a single letter or the whole word"
    begin 
      guess = gets.chomp
      raise GameError unless guess =~ /^[a-zA-Z]+$/
    rescue 
      "please enter a letter or a word"
      retry
    end
    guess
  end
  
end

  
class ComputerGuesser < Guesser
  
  attr_accessor :possible_words
  
  def get_guess(word_so_far, turns_left)
    p word_so_far, turns_left
    @guessed ||= []
    @possible_words ||= @dictionary.dup
    narrow_down_guesses(word_so_far)
    guess = (turns_left == 0 || @possible_words.length == 1) ? guess_word : guess_letter
    puts "my guess is #{guess}"
    guess
  end
  
  def guess_word
    @possible_words.sample
  end
  
  def guess_letter
    freq_hash = Hash.new(0)
    @possible_words.each do |word|
      word.split("").each { |letter| freq_hash[letter] += 1 }
    end
    freq_hash.delete_if { |k, v| @guessed.include?(k) }
    letter = freq_hash.to_a.sort_by{ |el| el.last}.reverse![0..2].sample.first
    @guessed << letter
    letter
  end
  
  def narrow_down_guesses(word_so_far)
    wildcard = @guessed.empty? ? "." : "[^#{ @guessed.join("") }]"
    regex_string = word_so_far.map { |el| el.nil? ? wildcard : el }.join("")
    regex = Regexp.new("^#{ regex_string }$")
    @possible_words.select! { |word| word =~ regex }
  end
end
