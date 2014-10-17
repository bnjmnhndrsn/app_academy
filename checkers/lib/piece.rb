require 'debugger'
class Piece
  
  DIFFS = {
    white: [
      [1, -1], [1, 1]
    ],
    black: [
      [-1, -1], [-1, 1]
    ]
  }
  
  attr_reader :color, :kinged, :position
  
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
  
  def can_jump_from_there?(moves)
    duped = @board.dup
    duped[@position].perform_moves!(moves)
    jumps = duped[moves.last].possible_jumps.select do |move|
      p move
       valid_jump?(move[:jumped], move[:dest])
    end
    jumps.length > 0
  end
  
  def possible_slides
    get_diffs.map do |diff|
        [@position.first + diff.first, @position.last + diff.last]
    end.select do |move|
      on_board?(move)
    end
  end
  
  def possible_jumps
    get_diffs.map do |diff|
          { jumped: [@position.first + diff.first, @position.last + diff.last],
            dest: [@position.first + (2 * diff.first), @position.last + (2 * diff.last)] }
    end.select do |move|
      on_board?(move[:jumped]) && on_board?(move[:dest])
    end
  end
  
  def on_board?(pos)
    pos.first.between?(0, 7) && pos.last.between?(0, 7)
  end
  
  def perform_jump(dest)
    
    possible_moves = possible_jumps
    
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
    (@position.first == 7  && @color == :white) || (@position.first == 0 && @color == :black)
  end
  
  def promote
    @kinged = true
  end
  
  def perform_moves(seq)
     if valid_move_seq?(seq)
       perform_moves!(seq)
     else
       raise InvalidMoveError.new("You can't make that move!")
     end
  end
  
  
  def perform_moves!(seq)
    if seq.length == 1
      raise InvalidMoveError unless (perform_slide(seq[0]) || perform_jump(seq[0]))
    else
      raise InvalidMoveError unless seq.all? { |move| perform_jump(move) }
    end
  end
  
  def valid_move_seq?(seq)
    duped_board = @board.dup
    duped_piece = duped_board[@position]
    begin
      duped_piece.perform_moves!(seq)
    rescue InvalidMoveError
      return false
    end
    true
  end
  
end

class InvalidMoveError < RuntimeError
end