require_relative 'sliding'

class Rook < SlidingPiece
  def get_diffs
    ChessConstants::STRAIGHTS
  end
end
