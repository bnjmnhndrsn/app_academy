require_relative 'piece'

class SteppingPiece < Piece
  def moves_on_board
    moves = []

    get_diffs.each do |diff|
      x, y = position.first + diff.first, position.last + diff.last
      moves << [x, y] if x.between?(0, 7) && y.between?(0, 7)
    end

    moves
  end
end
