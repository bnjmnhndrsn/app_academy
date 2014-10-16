require_relative 'piece'
require_relative '../chess/board_ui'

class Board
  
  def initialize
    @grid = Board.create_empty_grid
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
    raise "Board needs array accessor" unless coord.is_a?(Array) #take out after debugging
    @grid[coord.first][coord.last]
  end
  
  def []=(coord, val)
    raise "Board needs array accessor" unless coord.is_a?(Array) #take out after debugging
    @grid[coord.first][coord.last] = val
  end

end

b = Board.new
pos1 = [4, 4]
b[pos1] = Piece.new(:white, pos1, b)
pos2 = [5, 5]
b[pos2] = Piece.new(:white, pos2, b)
pos3 = [3, 5]
b[pos3] = Piece.new(:black, pos3, b)

ui = BoardUI.new
ui.load(b.serialize)
ui.display