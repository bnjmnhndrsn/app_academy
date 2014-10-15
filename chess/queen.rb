require_relative 'sliding'

class Queen < SlidingPiece
  def get_diffs
    ChessConstants::DIAGONAL + ChessConstants::STRAIGHTS
  end
end
