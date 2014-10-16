require_relative 'piece'
require_relative '../../chess/board_ui'

class Board
  
  def initialize
    @grid = Board.create_empty_grid
  end
  
  def self.make_beginning_board
    Board.new.setup_pieces
  end
  
  def self.create_empty_grid
    Array.new(8) { Array.new(8) }
  end
  
  def serialize
    @grid.map do |row|
       row.map do |square|
         square.nil? ? "_" : square.color.to_s[0]
       end
     end
  end
  
  def [](coord)
    @grid[coord.first][coord.last]
  end
  
  def []=(coord, val)
    @grid[coord.first][coord.last] = val
  end
  
  def dup
    duped = Board.new
    find_all.each do |piece|
      duped[piece.position] = Piece.new(piece.color, piece.position, duped)
    end
    duped
  end

  def find_all(&blk)
    if block_given?
      @grid.flatten.compact.select { |piece| blk.call(piece) }
    else
      @grid.flatten.compact
    end
  end

  def setup_pieces
    (0..7).each do |row|
      col_values = (0..7).to_a.select { |col| col.odd? ? col.odd? : col.even? }
      color = (row > 4 ? :black : :white)
      unless row.between?(3, 4)
        col_values.each do |col|
          pos = [row, col]
          self[pos] = Piece.new(color, pos, self)
        end
      end
    end
    self
  end
  
end