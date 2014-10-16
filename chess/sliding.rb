require_relative 'piece'

class SlidingPiece < Piece
  def moves_on_board
    moves = []

    get_diffs.each do |diff|
      (1..7).each do |scalar|
        move = [position.first + diff.first * scalar, position.last + diff.last * scalar]
        if @board.valid_position?(move)
          moves << move
        else
          break
        end
      end
    end

    moves
  end
end
