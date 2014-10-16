require_relative 'stepping'

class King < SteppingPiece
  def get_diffs
    ChessConstants::DIAGONALS + ChessConstants::STRAIGHTS
  end
end
