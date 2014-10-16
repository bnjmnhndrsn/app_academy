require_relative 'piece'

class SteppingPiece < Piece
  
  def moves
    moves = []

    get_diffs.each do |diff|
      x, y = position.first + diff.first, position.last + diff.last
      moves <<  [x, y] if @board.valid_move?(position, [x, y])
    end
    moves
  end
end
