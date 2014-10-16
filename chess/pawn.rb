require_relative 'piece'

class Pawn < Piece
  attr_accessor :moved

  def moves
    moves = []
    if @board.valid_move?(position, single_advance)
      moves << single_advance
      moves << double_advance if moved && @board.valid_move?(position, double_advance)
    end  
    
    moves += [attack_left, attack_right].select do |move|
      @board.valid_move?(position, move) && @board.attacking?(position, move)
    end

  end

  def direction
    (color == :black ? 1 : -1)
  end

  def single_advance
    [position.first + direction, position.last]
  end

  def double_advance
    [position.first + (2 * direction), position.last]
  end

  def attack_right
    [position.first + direction, position.last + 1]
  end

  def attack_left
    [position.first + direction, position.last - 1]
  end
  
  def position=(new_position)
    @position = new_position
    @moved = true
  end
  
end
