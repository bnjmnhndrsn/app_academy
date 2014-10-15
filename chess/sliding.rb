require_relative 'piece'

class SlidingPiece < Piece
  def moves_on_board
    moves = []

    get_diffs.each do |diff|
      (1..7).each do |scalar|
        x = position.first + diff.first * scalar
        y = position.last + diff.last * scalar
        moves << [x, y] if x.between?(0, 7) && y.between?(0, 7)
      end
    end

    moves
  end
end
