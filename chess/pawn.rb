require_relative 'piece'

class Pawn < Piece
  attr_accessor :moved

  def moves_on_board
    moves = []
    if valid_move?(single_advance)
      moves << single_advance
      moves << double_advance if moved && @board.valid_move?(double_advance)
    end  
    
    moves += [attack_left, attack_right].select do |move|
      @board.on_board?(move) && @board.attacking?(position, move)
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
