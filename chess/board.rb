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
  attr_accessor :grid, :selected

  def self.create_board
    Array.new(8) { Array.new(8) }
  end

  def populate_board
    ChessConstants::DEFAULT_BOARD.each do |piece, colors|
      colors.each do |color, positions|
        positions.each do |pos|
          self[pos.first, pos.last] = piece.new(self, pos, color)
        end
      end
    end
  end
  
  def to_s
    str = "  a b c d e f g h\n"
    str += @grid.map.with_index do |row, i|
      "#{8 - i} " + row.map.with_index do |space, j|
        char = (space.nil? ? ChessConstants::SKINS[nil] : 
        ChessConstants::SKINS[space.color][space.class])
        selected == [i, j] ? char.colorize(:white).on_black : char 
      end.join(' ')
    end.join("\n")
  end

  def initialize(setup = true)
    @grid = Board.create_board
    populate_board if setup
    @selected = [6,4]
  end

  def validate_move(color, from, to)
    check_no_piece(from)
    check_not_your_piece(color, from)
    check_attack_self(from, to)

    selected_move = self[from[0], from[1]].moves_on_board.find do |move|
      move.destination == to
    end

    check_not_a_move(selected_move)
    check_piece_in_way(selected_move)
  end

  def check_not_your_piece(color, from)
    x, y = from
    raise MoveError.new("Isn't your piece!") if self[x, y].color != color
  end

  def check_no_piece(from)
    x, y = from
    raise MoveError.new("There's no piece there!") if self[x, y].nil?
  end

  def check_attack_self(from, to)
    x, y = from
    w, z = to
    if !self[w, z].nil? && self[x, y].color == self[w, z].color
      raise MoveError.new("You can't take your own piece, buddy.")
    end
  end

  def check_not_a_move(move)
    raise MoveError.new('Not a legal move for that piece.') if move.nil?
  end

  def check_piece_in_way(move)
    unless move.sequence.all? { |pos| self[pos[0], pos[1]].nil? }
      raise MoveError.new("There's a piece in the way!")
    end
  end

  def move_piece!(from, to)
    self[to[0], to[1]] = self[from[0], from[1]]
    self[from[0], from[1]] = nil
    self[to[0], to[1]].position = to
    self
  end

  def in_check?(color)
    opponent_color = (color == :white ? :black : :white)
    kings_location = king_position(color)
    move_array = all_possible_moves(opponent_color).map(&:destination)
    move_array.include?(kings_location)
  end

  def all_possible_moves(color)
    moves = []

    @grid.flatten.compact.each do |piece|
      piece.moves_on_board.each do |move|
        begin
          validate_move(color, piece.position, move.destination)
          moves << move
        rescue MoveError
          next
        end
      end
    end

    moves
  end

  def will_result_in_check?(color, start, destination)
    clone_board.move_piece!(start, destination).in_check?(color)
  end

  def king_position(color)
    @grid.flatten.compact.find do |piece|
      piece.color == color && piece.is_a?(King)
    end.position
  end

  def checkmate?(color)
    all_possible_moves(color).all? do |move|
      will_result_in_check?(color, move.start, move.destination)
    end
  end

  def clone_board
    clone = Board.new(false)

    @grid.flatten.compact.each do |piece|
      cloned_piece = piece.class.new(clone, piece.position.dup, piece.color)
      cloned_piece.moved = cloned_piece.moved if cloned_piece.is_a?(Pawn)
      clone[piece.position.first, piece.position.last] = cloned_piece

    end

    clone
  end

  def [](x, y)
    @grid[x][y]
  end

  def []=(x, y, val)
    @grid[x][y] = val
  end

  def attacking?(pos1, pos2)
    return false if self[pos1[0], pos1[1]].nil? || self[pos2[0], pos2[1]].nil?
    self[pos1[0], pos1[1]].color != self[pos2[0], pos2[1]].color
  end
end

class MoveError < StandardError
end
