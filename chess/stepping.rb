require_relative 'piece'

class SteppingPiece < Piece
  def moves_on_board
    moves = []

    get_diffs.each do |diff|
      x, y = position.first + diff.first, position.last + diff.last
      next unless x.between?(0, 7) && y.between?(0, 7)
      new_move = Move.new
      new_move.start = position
      new_move.destination = [x, y]
      new_move.sequence = []
      moves << new_move
    end

    moves
  end
end
