require_relative 'piece'

class Pawn < Piece
  
  attr_accessor :moved
  
  def initialize(board, position, color)
    super
    @moved = false
  end
  
  # def get_diffs
#     if self.color == :black
#       [[1, 0], [1, -1], [1, 1]] + (@moved ? [] : [2, 0])
#     elsif self.color == :white
#       [[-1, 0], [-1, -1], [-1, 1]] + (@moved ? [] : [-2, 0])
#     end
#   end
  
  def moves_on_board
    moves = []
    sign = (self.color == :black ? 1 : -1)
    moves << [position.first + (2 * sign), position.last] unless moved
    moves << [position.first + (1 * sign), position.last]
    attack_left = [position.first + (1 * sign), position.last + 1]
    attack_right = [position.first + (1 * sign), position.last - 1]
    moves << attack_left
    moves << attack_right
    moves.keep_if { |pos| on_board?(pos) }
    moves.delete(attack_left) unless @board.attacking?(position, attack_left)
    moves.delete(attack_right) unless @board.attacking?(position, attack_right)
    moves
  end
  
  private
  
  def on_board?(position)
    position.first.between?(0, 7) && position.last.between?(0, 7)
  end

end