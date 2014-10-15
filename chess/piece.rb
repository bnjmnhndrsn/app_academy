class Piece
  attr_accessor :position, :color

  def initialize(board, position, color)
    @board, @position, @color = board, position, color
  end

  def valid_moves
    raise 'not implemented error'
  end
end
