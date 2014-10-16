require_relative 'piece'
require_relative 'king'
require_relative 'queen'
require_relative 'knight'
require_relative 'bishop'
require_relative 'rook'
require_relative 'pawn'
require_relative 'chess_constants'
require 'colorize'

class Board
  attr_accessor :selected
  
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
          self[pos] = piece.new(self, pos, color))
        end
      end
    end
  end
  
  def serialize
    @grid.map.with_index do |row|
      row.map do |space|
        space.nil? ? ChessConstants::SKINS[nil] : 
        ChessConstants::SKINS[space.color][space.class]
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

  def initialize(grid)
    @grid = grid || Board.create_empty_grid
    @selected = [6,4]
  end
  
  def valid_move?(from, to)
    !attacking_self?(from, to) && on_board?(to)
  end
  
  def validate_from(from)
    
  end
  
  def validate_to(from, to)
    if @board.will_result_in_check?(turn, move.first, move.last)
      raise MoveError.new("Don't check yourself before you wreck yourself.")
    end
  end

  def attacking_self(from, to)
    self[to].nil? || self[from].color == self[w, z].color
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
      @grid.flatten.compact.find { |piece| blk.call(piece) }
    else
      @grid.flatten.compact
  end

  def all_possible_moves(color)
    search_pieces { |piece| piece.color == color }.map(&:moves).flatten
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
    all_possible_moves(color).all? do |move|
      will_result_in_check?(color, move)
    end
  end

  def clone_board
    new_board = Board.create_empty_grid
    
    search_pieces.each do |piece|
      new_piece = piece.class.new(new_board, piece.position.dup, piece.color)
      new_piece.moved = piece.moved if piece.respond_to?(:moved)
      new_board[new_piece.position] = cloned_piece
    end
    
    new_board
  end

  def [](coord)
    @grid[coord.first][coord.last]
  end

  def []=(coord, val)
    @grid[coord.first][coord.last] = val
  end

  def attacking?(pos1, pos2)
    return false if self[pos1].nil? || self[pos2].nil?
    self[pos1].color != self[pos2].color
  end
end

class MoveError < StandardError
end
