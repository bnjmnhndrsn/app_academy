require_relative 'sliding'

class Queen < SlidingPiece
  def get_diffs
    ChessConstants::DIAGONALS + ChessConstants::STRAIGHTS
  end
end
