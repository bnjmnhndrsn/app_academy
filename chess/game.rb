require_relative 'board'
require 'io/console'

class Game
  attr_accessor :board, :turn

  class InputError < StandardError
  end

  def play
    self.board = Board.new
    self.turn = :white

    until board.checkmate?(turn)
      print_board
      take_turn
      change_turn
    end

    board.render
    puts "Checkmate! #{turn.capitalize} loses!".rjust(16)
  end
  
  def process_action(action)
    i, j = board.selected
    
    case action
    when "W"
      self.board.selected = [(i - 1) % 8, j]
    when "A"
      self.board.selected = [i, (j - 1) % 8]
    when "S"
      self.board.selected = [(i + 1) % 8, j]
    when "D"
      self.board.selected = [i, (j + 1)  % 8]
    when " "
      return self.board.selected
    when "P"
      fail "quitting gracefully"
    end
    false
  end
  
  def get_move
    from = false
    until from  
      print_board
      action = get_user_input
      from = process_action(action)
    end
    
    to = false
    until to
      print_board 
      action = get_user_input
      to = process_action(action)
    end
    
    [from, to]
  end
  
  def get_user_input
    char = STDIN.getch.upcase
    
    until ChessConstants::VALID_INPUT_CHARS.include?(char)
      puts "Use W, A, S, D to move cursor."
      char = STDIN.getch.upcase
    end
    
    char
  end
  
  def change_turn
    self.turn = (turn == :white ? :black : :white)
  end
  
  def print_board
    system('clear')
    puts 'King is in check!'.rjust(16) if board.in_check?(turn)
    puts "#{turn.capitalize}'s move!".rjust(16)
    puts board.to_s
  end

  def take_turn
    move = get_move
    board.validate_move(turn, move.first, move.last)
    if @board.will_result_in_check?(turn, move.first, move.last)
      raise MoveError.new("Don't check yourself before you wreck yourself.")
    end
    board.move_piece!(move.first, move.last)
  rescue MoveError => e
    puts e.message
    retry
  rescue InputError => e
    puts e.message
    retry
  end
end

g = Game.new
g.play
