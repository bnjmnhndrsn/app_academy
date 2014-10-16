require 'io/console'

class BoardUI
  
  attr_accessor :grid
  
  def initialize(size = 8)
    @size = size
    @cursor = [0,0]
    @grid = nil
    @selected = []
  end
  
  def display(spaces = 1)
    raise "No grid to display!" if @grid.nil?
    
    first_row = ("a".."z").to_a[0...@size].join(" " * spaces)
    col_numbers = (1..@size).to_a.reverse
    
    rows = @grid.map.with_index do |row, i|
       "#{col_numbers[i]} " + row.map.with_index do |space, j|
        if [i, j] == @cursor
          "0"
        elsif @selected.include?([i, j])
          "X"
       else
          space
        end
      end.join(" " * spaces)
    end.join("\n")
    
    puts " #{first_row}\n#{rows}"
  end
  
  def get_selection(message)
    current_message = message
    selection = nil
    until selection
      begin
        system("clear")
        display
        print(current_message) if current_message
        input = STDIN.getch
        selection = process_input(input)
      rescue InputError => e
        current_message = e.message
        retry
      end
    end
    selection
  end
  
  def place_cursor(coord)
    @cursor = coord
  end
  
  def clear_selection
    @selected = []
  end
  
  def process_input(input)
    i, j = @cursor

    case input
    when "w"
      @cursor = [(i - 1) % @size, j]
    when "a"
      @cursor = [i, (j - 1) % @size]
    when "s"
      @cursor = [(i + 1) % @size, j]
    when "d"
      @cursor = [i, (j + 1)  % @size]
    when "\r"
      return @cursor
    when "\u0003"
      fail "quitting gracefully"
    else
      raise InputError.new("Please use WASD to move and enter to select")
    end
    false
  end
end

class InputError < RuntimeError
end

ui = BoardUI.new
ui.grid = Array.new(8) { Array.new(8) { "|" } }
p ui.get_selection("Get a selection")