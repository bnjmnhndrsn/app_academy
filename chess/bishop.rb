require_relative 'sliding'

class Bishop < SlidingPiece
  def get_diffs
    ChessConstants::DIAGONALS
  end
end
