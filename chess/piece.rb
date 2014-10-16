class Piece
  attr_accessor :position, :color
  
  def initialize(board, position, color)
    @board, @position, @color = board, position, color
  end
  
  def moves_on_board
    raise "deprecation error"
  end
end
