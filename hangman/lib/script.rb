require_relative './hangman'

if $PROGRAM_NAME == __FILE__
  dictionary = File.readlines('dictionary.txt').map(&:chomp)
  e = Executioner.new("E", dictionary)
  g = ComputerGuesser.new("G", dictionary)
  hangman = Hangman.new
  hangman.run(e, g, 10)
end