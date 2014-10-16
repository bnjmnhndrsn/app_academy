require_relative 'piece'

class SlidingPiece < Piece
  def moves_on_board
    moves = []

    get_diffs.each do |diff|
      coords_in_direction = []

      (1..7).each do |scalar|
        x = position.first + diff.first * scalar
        y = position.last + diff.last * scalar
        next unless x.between?(0, 7) && y.between?(0, 7)
        new_move = Move.new
        coords_in_direction += [[x, y]]
        new_move.start = position
        new_move.destination = coords_in_direction.last
        new_move.sequence = coords_in_direction[0...-1]
        moves << new_move
      end
    end

    moves
  end
end
