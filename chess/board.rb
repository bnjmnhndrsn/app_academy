require_relative 'piece'
require_relative 'king'
require_relative 'queen'
require_relative 'knight'
require_relative 'bishop'
require_relative 'rook'
require_relative 'pawn'
require_relative 'chess_constants'
require 'debugger'
#require 'colorize'

class Board
  
  def initialize(grid = nil)
    @grid = grid || Board.create_empty_grid
  end
  
  def self.make_starting_board
    self.new.populate_board
  end

  def self.create_empty_grid
    Array.new(8) { Array.new(8) }
  end
  
  def add_piece(position, piece)
  end

  def populate_board
    ChessConstants::DEFAULT_BOARD.each do |piece, colors|
      colors.each do |color, positions|
        positions.each do |pos|
          self[pos] = piece.new(self, pos, color)
        end
      end
    end
    
    self
  end
  
  def serialize
    @grid.map.with_index do |row|
      row.map do |space|
        space.nil? ? ChessConstants::SKINS[nil] : ChessConstants::SKINS[space.color][space.class]
      end
    end
  end 
  
  def to_s
    str = "  a b c d e f g h\n"
    str += @grid.map.with_index do |row, i|
      "#{8 - i} " + row.map.with_index do |space, j|
        char = (space.nil? ? ChessConstants::SKINS[nil] : 
        ChessConstants::SKINS[space.color][space.class])
        selected == [i, j] ? "0" : char 
      end.join(' ')
    end.join("\n")
  end 
  
  def valid_move?(from, to)
    on_board?(to) && !attacking_self?(from, to)
  end
  
  def attacking_self?(from, to)
    p self.class, from, to
    self[to].is_a?(Piece) && self[from].color == self[to].color
  end
  
  def on_board?(pos)
    pos.first.between?(0, 7) && pos.last.between?(0, 7)
  end

  def move_piece!(from, to)
    self[to] = self[from]
    self[from] = nil
    self[to].position = to
    self
  end

  def in_check?(color)
    opponent_color = (color == :white ? :black : :white)
    kings_location = king_position(color)
    moves = all_possible_moves(opponent_color)
    moves.include?(kings_location)
  end
  
  def search_pieces(&blk)
    if block_given?
      @grid.flatten.compact.find_all { |piece| blk.call(piece) }
    else
      @grid.flatten.compact
    end
  end

  def all_possible_moves(color)
    moves = []
    search_pieces { |piece| piece.color == color }.each do |piece|
      piece.moves.each do |move|
        moves << {from: piece.position, to: move}
      end
    end
    moves
  end

  def will_result_in_check?(color, from, to)
    clone_board.move_piece!(from, to).in_check?(color)
  end

  def king_position(color)
    search_pieces do |piece| 
      piece.color == color && piece.is_a?(King) 
    end.first.position
  end

  def checkmate?(color)
    all_possible_moves(color).all? do |hash|
      will_result_in_check?(color, hash[:from], hash[:to])
    end
  end

  def clone_board
    new_board = Board.new
    
    search_pieces.each do |piece|
      new_piece = piece.class.new(new_board, piece.position.dup, piece.color)
      new_piece.moved = piece.moved if piece.respond_to?(:moved)
      new_board[new_piece.position] = new_piece
    end
    
    new_board
  end

  def [](coord)
    return nil unless coord.first.between?(0, 7) && coord.last.between?(0, 7)
    @grid[coord.first][coord.last]
  end

  def []=(coord, val)
    return nil unless coord.first.between?(0, 7) && coord.last.between?(0, 7)
    @grid[coord.first][coord.last] = val
  end

  def attacking?(pos1, pos2)
    return false if self[pos1].nil? || self[pos2].nil?
    self[pos1].color != self[pos2].color
  end
end

class MoveError < StandardError
end
