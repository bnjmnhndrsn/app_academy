require 'debugger'
class Piece
  
  DIFFS = {
    black: [
      [1, -1], [1, 1]
    ],
    white: [
      [-1, -1], [-1, 1]
    ]
  }
  
  attr_reader :color, :kinged
  
  def initialize(color, position, board)
    @color, @position, @board, @kinged = color, position, board, false
  end
  
  def perform_slide(dest)
    possible_moves = get_diffs.map do |diff|
      [@position.first + diff.first, @position.last + diff.last]
    end
    
    valid = possible_moves.include?(dest) && @board[dest].nil?
    
    self.move_to(dest) if valid
    
    valid
  end
  
  def perform_jump(dest)
    
    possible_moves = get_diffs.map do |diff|
      { jumped: [@position.first + diff.first, @position.last + diff.last],
        dest: [@position.first + (2 * diff.first), @position.last + (2 * diff.last)] }
    end
    
    selected_move = possible_moves.find do |move|
       valid_jump?(move[:jumped], move[:dest]) && move[:dest] == dest
     end
    
    unless selected_move.nil?
      self.move_to(selected_move[:dest])
      @board[selected_move[:jumped]].remove
    end
    
    !!selected_move
  end
  
  def valid_jump?(jumped, dest)
    @board[jumped].is_a?(Piece) && @board[jumped].color != @color && @board[dest].nil?
  end
  
  def remove
    @board[@position] = nil
    @position = nil
  end
  
  def move_to(coord)
    self.remove
    @board[coord] = self
    @position = coord
    self.promote if self.maybe_promote?
  end
  
  def get_diffs
    if @kinged
      DIFFS[:black] + DIFFS[:white]
    else
      DIFFS[@color]
    end
  end
  
  def maybe_promote?
    (@position.first == 0  && @color == :white) || (@position.first == 7 && @color == :black)
  end
  
  def promote
    @kinged = true
  end
  
  def perform_moves!(seq)
    seq.all? do |move|
      
    end 
  
end