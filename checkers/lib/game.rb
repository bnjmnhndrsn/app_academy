require_relative 'board'
require_relative '../../chess/board_ui'

class Game
  def run
    @board = Board.make_beginning_board
    @ui = BoardUI.new
    @turn = :white
    
    until over?
      do_turn
      change_turn
    end
    
  end
  
  def do_turn
    begin
      @ui.title = "#{@turn.to_s.upcase}'s turn!"
      @ui.selected = []
      @ui.load(@board.serialize)
      piece = get_piece_to_move
      moves = get_places_to_move(piece)
      piece.perform_moves(moves)
    rescue InvalidMoveError => e
      @ui.selected = []
      @ui.flash = e.message
      retry
    end
  end
  
  def change_turn
    @turn = (@turn == :white ? :black : :white)
  end
  
  def get_piece_to_move
    @ui.selected = []
    input = nil
    until input
      input = @ui.get_selection("Press enter to select the piece you want to move.")
    end
    square = @board[input] 
    raise InvalidMoveError.new("There's nothing there!") if square.nil?
    raise InvalidMoveError.new("That's not your piece!") if square.color != @turn
    square
  end
  
  def get_places_to_move(piece)
    @ui.selected = []
    msg = "Select where you want to move."
    moves = []
    loop do
      input = @ui.get_selection(msg)
      raise InvalidMoveError.new("Selection cancelled.") unless input
      moves << input
      was_a_jump = (input.first - piece.position.first).abs + 
        (input.last - piece.position.last).abs == 4
      break unless was_a_jump && piece.can_jump_from_there?(moves)  &&
       @ui.ask_question("Do you want to keep double jumping? (y/n)")
    end
    moves
  end
  
  def over?
    loser?(:white) || loser?(:black) || stalemate? 
  end
  
  def loser?(color)
    @board.find_all { |piece| piece.color == color}.empty?
  end
  
  def stalemate?
    pieces = @board.find_all
    pieces.length == 2 && pieces.first.color != pieces.last.color
  end
  
end

g = Game.new
g.run