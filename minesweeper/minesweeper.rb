require 'yaml'
require 'colorize'
require 'io/console'

class DisplayError < RuntimeError
end
class InputError < RuntimeError
end

class Minesweeper


  def play
    load_game
    
    until @board.over?
      
      @board.display
      action = take_action
      if action == 's'
        break if save_and_quit
      end
      coord = take_coord
      change_board(action, coord)
    end
    display_result
  end
  
  def play_gui
    load_game
    
    until @board.over?
      
      @board.display
      action = get_keypress
      if action == "q"
        save_and_quit
        break
      end
      take_action_gui(action)
    end
    display_result
  end
  
  def get_keypress
    opts = ['q','r','f','w','a','s','d']
    key = STDIN.getch
    until opts.include?(key)
      key = STDIN.getch
    end
    key
  end
  
  def take_action_gui(action)
    cur_row, cur_col = @board.current_selection.pos
    
    case action
    when "r"
      @board.current_selection.reveal
    when "f"
      @board.current_selection.flag
    when "w"
      @board.select([cur_row - 1, cur_col])
    when "a"
      @board.select([cur_row, cur_col - 1])
    when "s"
      @board.select([cur_row + 1, cur_col])
    when "d"
      @board.select([cur_row, cur_col + 1])
    end
    
  end
  
  def display_result
    puts @board.display if @board.over?
    system("clear")
    puts %q{yaya} if @board.win?
    puts %q{               ____  , -- -        ---   -.                    
            (((   ((  ///   //   '  \\-\ \  )) ))              
        ///    ///  (( _        _   -- \\--     \\\ \)         
     ((( ==  ((  -- ((             ))  )- ) __   ))  )))       
      ((  (( -=   ((  ---  (          _ ) ---  ))   ))         
         (( __ ((    ()(((  \\  / ///     )) __ )))            
                \\_ (( __  |     | __  ) _ ))                  
                          ,|  |  |                             
                         `-._____,-'                           
                         `--.___,--'                           
                           |     |                             
                           |    ||                             
                           | ||  |                             
                 ,    _,   |   | |                             
        (  ((  ((((  /,| __|     |  ))))  )))  )  ))           
      (()))       __/ ||(    ,,     ((//\     )     ))))       
---((( ///_.___ _/    ||,,_____,_,,, (|\ \___.....__..  ))--ool
           ____/      |/______________| \/_/\__                
          /                                \/_/|               
         /  |___|___|__                        ||     ___      
         \    |___|___|_                       |/\   /__/|     
         /      |   |                           \/   |__|/     } if @board.lose?
  end
  
  def save_and_quit
    if @board.save_state
      puts "Game saved!"
      return true
    end
    false
  end
  
  def load_game
    system("clear")
    responses = ['n','new','l','load']
    puts "Start a new game? Or load last saved game? (n,l)"
      begin
        action = gets.chomp.downcase.strip
      raise InputError unless responses.include?(action)
      rescue InputError
        "Enter l or n"
        retry
      end
      
      if action == 'n'    
        @board = Board.new(9, 9)
      else
        f = File.read('saved_game')
        @board = YAML.load(f)
      end
  end
  
  def change_board(action, coord)
    row, col = coord
     if action == 'r' 
       @board[row, col].reveal
     elsif action == 'f'
       @board[row, col].flag
     end
  end
  
  def take_coord
    puts "Put in the coordinate!"
    begin
      guess = gets.chomp
      unless guess.match(/^\s*\d{1,2}\s*,\s*\d{1,2}\s*$/)
        raise InputError.new("Please write digits, separted by a comma")
      end 
      coord = guess.split(",").map { |char| char.to_i - 1 }
      range = (0...@board.size)
      unless range.cover?(coord.first) && range.cover?(coord.last)
        raise InputError.new("That's not on the board!")
      end
    rescue InputError => e
      puts e
      retry
    end
    coord
  end
  
  def take_action
    responses = ['r', 'reveal', 'f', 'flag', 's', 'save']
    puts "Do you want to reveal or flag a space or save? (r, f, s)"
    begin
      action = gets.chomp.downcase.strip
    raise InputError unless responses.include?(action)
    rescue InputError
      "Enter f, r, or s"
      retry
    end    
    action[0]
  end
  
  
end

class Tile
  attr_reader :pos
  
  def initialize(board, pos, bomb)
    @pos = pos
    @board = board
    @revealed = false
    @bomb = bomb
    @flagged = false
    @selected = false
  end
    
  def to_s
        #
    # checkmark = "\u2713"
    # puts checkmark.encode('utf-8')

    if !revealed? && !flagged?
      return "   ".on_red
    elsif flagged?
      return " \u05d0 ".encode('utf-8').on_red
    elsif revealed? && !bomb?
      return " #{neighbor_bombs} ".on_green
    elsif bomb?
      "[X]"
    else
      raise DisplayError
    end
    
    
  end
    
  def neighbor_bombs
    @board.find_neighbors(@pos).count { |neighbor| neighbor.bomb? }
  end
    
  def bomb?
    @bomb
  end
  
  def flagged?
    @flagged
  end
  
  def revealed?
    @revealed
  end
  
  def selected?
    @selected
  end
  
  def select
    @selected = !@selected
  end
  
  def reveal
    @revealed = true
    if neighbor_bombs == 0
      neighbors = @board.find_neighbors(@pos).each do |neighbor|
        neighbor.reveal unless neighbor.revealed?
      end
    end
  end
  
  def flag
    @flagged = !@flagged
  end
  
end

class Board
  
  attr_reader :size, :current_selection
  def initialize(size, bomb_count)
    @size = size
    @bomb_count = bomb_count
    @grid = create_grid
    select([0,0])

  end
  
  def create_grid
    random_bomb_locations = (0...(@size * @size)).to_a.sample(@bomb_count)
    
    Array.new(@size) do |i|
      Array.new(@size) do |j|
        Tile.new(self, [i, j], random_bomb_locations.include?(i * @size + j))
      end
    end
  end
  
  def display
    system("clear")
    
    output = @grid.map do |row|
      row.map do |tile| 
        tile.selected? ? tile.to_s.on_white : tile.to_s
      end.join('')
    end.join("\n")
    
    puts output
    puts "WASD to move; 'f' to flag; 'r' to reveal; 'q' to save and quit"
  end
    
  
  def over?
    win? || lose?
  end
  
  def win?
    unflagged_bomb = false
    unrevealed_tile = false
    revealed_bomb = false
    flagged_non_bomb = false
    
    @grid.each do |row|
      row.each do |tile|
        flagged_non_bomb = true if !tile.bomb? && tile.flagged?
        revealed_bomb = true if tile.bomb? && tile.revealed?
        unflagged_bomb = true if tile.bomb? && !tile.flagged?
        unrevealed_tile = true if !tile.bomb? && !tile.revealed?
      end
    end
    
    if (!unflagged_bomb || !unrevealed_tile) && !revealed_bomb && !flagged_non_bomb
      return true
    end
    
    false
  end
  
  def lose?
    @grid.each do |row|
      row.each do |tile|
        return true if tile.bomb? && tile.revealed?
      end
    end
    false
  end

  
  def find_neighbors(pos)
    row, col = pos
    neighbors = []
    vectors = [[1, 1], [1, 0], [1, -1], [0, -1], [0, 1], [-1, -1], [-1, 0], [-1, 1]]
    vectors.each do |vector|
      new_row, new_col = row + vector.first, col + vector.last
      if (0...@size).cover?(new_row) && (0...@size).cover?(new_col)
       neighbors << @grid[new_row][new_col]
      end
    end
    neighbors 
  end
  
  def [](row, col)
    @grid[row][col]
  end
  
  def []=(row, col, val)
    @grid[row][col] = val
  end

  def save_state
    f = File.open("saved_game", "w")
    f.puts self.to_yaml
    f.close
    true
  end
  
  def select(new_pos)
    row, col = new_pos
    col = col % @size if col >= @size
    row = row % @size if row >= @size
    
    @current_selection.select if @current_selection
    @current_selection = self[row, col]
    @current_selection.select
  end
  
end


if $PROGRAM_NAME == __FILE__
   game = Minesweeper.new
   game.play_gui

end