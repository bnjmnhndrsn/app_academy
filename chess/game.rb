require_relative 'board'

class Game
  attr_accessor :board, :turn

  class InputError < StandardError
  end
  #a comment
  def play
    self.board = Board.new
    self.turn = :white

    until board.over?
      system('clear')
      puts "#{turn.capitalize}'s move!"
      board.render
      take_turn

      self.turn = (turn == :white ? :black : :white)
    end
  end

  def take_turn
    print 'Enter a move: '
    move = gets.scan(/\d/).map(&:to_i)
    p move
    if move.length != 4
      raise InputError.new('You must enter exactly 4 digits.')
    end

    board.move_piece!(turn, move[0..1], move[2..3])
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
