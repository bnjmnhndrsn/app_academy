require_relative 'stepping'

class Knight < SteppingPiece
  def get_diffs
    [[-2, -1], [-2, 1], [2, 1], [2, -1], [-1, 2], [-1, -2], [1, 2], [1, -2]]
  end
end
