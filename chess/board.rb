require_relative 'piece'
require_relative 'king'
require_relative 'queen'
require_relative 'knight'
require_relative 'bishop'
require_relative 'rook'
require_relative 'pawn'
require_relative 'chess_constants'

class Board
  attr_accessor :grid

  def self.create_board
    Array.new(8) { Array.new(8) }
  end

  def populate_board
    ChessConstants::DEFAULT_BOARD.each do |piece, colors|
      colors.each do |color, positions|
        positions.each do |pos|
          @grid[pos.first][pos.last] = piece.new(self, pos, color)
        end
      end
    end
  end

  def initialize(grid = Board.create_board)
    @grid = grid
    populate_board
  end

  def validate_move(player_color, from, to)
    if self[from[0], from[1]].nil?
      raise MoveError.new("There's no piece there!")
    end

    if self[from[0], from[1]].color != player_color
      raise MoveError.new('Try moving your own piece for a change!')
    end

    unless self[from[0], from[1]].moves_on_board.include?(to)
      raise MoveError.new('Not a legal move for that piece.')
    end

    raise MoveError.new("You can't check yourself.") if in_check?
  end

  def move_piece!(player_color, from, to)
    validate_move(player_color, from, to)
    self[to[0], to[1]] = self[from[0], from[1]]
    self[from[0], from[1]] = nil
    self[to[0], to[1]].position = to
  end

  def in_check?
    # do something
  end

  def over?
  end

  def render
    str = "  0 1 2 3 4 5 6 7\n"
    str += @grid.map.with_index do |row, index|
      "#{index} " + row.map do |space|
        if space.nil?
          ChessConstants::SKINS[nil]
        else
          ChessConstants::SKINS[space.color][space.class]
        end
      end.join(' ')
    end.join("\n")
    puts str
  end

  def [](x, y)
    @grid[x][y]
  end

  def []=(x, y, val)
    @grid[x][y] = val
  end
  
  def attacking?(pos1, pos2)
    return false if self[pos1[0], pos1[1]].nil? || self[pos2[0], pos2[1]].nil?
    self[pos1[0], pos1[1]].color == self[pos2[0], pos2[1]].color
  end
end

class MoveError < StandardError
end
