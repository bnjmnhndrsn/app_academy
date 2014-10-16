require_relative 'board'
require 'io/console'

class Game
  attr_accessor :board, :turn

  class InputError < StandardError
  end
  
  def initialize
  end

  def play
    self.ui = BoardUI.new(ChessConstants::SKINS)
    self.board = Board.new
    self.turn = :white

    until board.checkmate?(turn)
      take_turn
      change_turn
    end

    ui.render(board.serialize)
    ui.print("Checkmate! #{turn.capitalize} loses!")
  end
  
  def change_turn
    self.turn = (turn == :white ? :black : :white)
  end
  
  def take_turn
    ui.place_cursor( (turn == :white ? 7 : 0 ), 4)
    from_square = ui.get_selection
    board.validate_from(turn, from_square)
    to_square = ui.get_selection
    board.validate_to(turn, from_square)
    board.move_piece!(move.first, move.last)
    ui.clear_selection
  rescue MoveError => e
    puts e.message
    retry

  end
end

g = Game.new
g.play
