require_relative 'piece'
require_relative '../../chess/board_ui'

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
    @grid[coord.first][coord.last]
  end
  
  def []=(coord, val)
    @grid[coord.first][coord.last] = val
  end

end

