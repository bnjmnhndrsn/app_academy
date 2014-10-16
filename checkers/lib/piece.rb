class Piece
  
  DIFFS = {
    black: [
      [1, -1], [1, 1]
    ],
    white: [
      [-1, -1], [-1, 1]
    ]
  }
  
  attr_reader :color
  
  def initialize(color, position, board)
    @color, @position, @board, @kinged = color, position, board, false
  end
  
  def perform_slide(dest)
    possible_moves = get_diffs.map do |diff|
      [position.first + diff.first, position.last + diff.last]
    end
    
    possible_moves.include?(dest) && board[dest].empty?
  end
  
  def perform_jump(dest)
    possible_moves = get_diffs.map do |diff|
      {
        jumped_sq: [position.first + diff.first, position.last + diff.last],
        dest_sq: [position.first + (2 * diff.first), position.last + (2 * diff.last)]
      }
    end
    
    possible_moves.any? do |move|
      !board[move[:jumped_sq]].empty? &&
         board[move[:jumped_sq]].color != @color &&
         board[moved[:dest_sq]].empty?
    end
  end
  
  def get_diffs
    DIFFS[:black] + DIFFS[:white] if @kinged 
    DIFFS[@color]
  end
  
end