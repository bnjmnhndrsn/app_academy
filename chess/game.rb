require_relative 'board'
require_relative '../../shared/lib/board_ui'
require 'io/console'

class Game

  class InputError < StandardError
  end
  
  def initialize
  end

  def play
    @ui = BoardUI.new
    @board = Board.make_starting_board
    @turn = :white

    until @board.checkmate?(@turn)
      take_turn
      change_turn
    end
    
    @ui.grid = board.serialize
    @ui.print("Checkmate! #{turn.capitalize} loses!")
  end
  
  def change_turn
    @turn = (@turn == :white ? :black : :white)
  end
  
  def take_turn
    @ui.grid = @board.serialize
    @ui.cursor = [(@turn == :white ? 7 : 0 ), 4]
    from = @ui.get_selection("Select a piece to move.")
    validate_from(@turn, from)
    to = @ui.get_selection("Select a destination.")
    validate_to(@turn, from, to)
    @board.move_piece!(from, to)
    @ui.selection = []
  rescue MoveError => e
    @ui.flash = e.message
    retry
  end
  
  def validate_from(turn, from)
    raise MoveError.new("There's no piece there!") if @board[from].nil?
    raise MoveError.new("Not your piece!") if @board[from].color != @turn
  end
  
  def validate_to(turn, from, to)
    raise MoveError.new("You can't go there!") unless @board[from].moves.include?(to)
    raise MoveError.new("You can't kill your own piece") if @board.attacking_self?(from, to) 
    raise MoveError.new("You can't put yourself in check.") if @board.will_result_in_check?(turn, from, to)
  end
end

g = Game.new
g.play
