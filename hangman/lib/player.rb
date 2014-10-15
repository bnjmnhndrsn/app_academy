class GameError < RuntimeError
end

class Player
  attr_reader :name
  
  def initialize(name, dictionary = nil)
    @name = name
    @dictionary = dictionary
  end
end