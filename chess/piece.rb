class Piece
  attr_accessor :position, :color

  Move = Struct.new(:start, :destination, :sequence)

  def initialize(board, position, color)
    @board, @position, @color = board, position, color
  end

  def valid_moves
    raise 'not implemented error'
  end
end
