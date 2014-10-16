require_relative 'piece'

class Pawn < Piece
  attr_accessor :moved

  def initialize(board, position, color)
    super
    @moved = false
  end

  def moves_on_board
    advances, attacks = [single_advance], [attack_left, attack_right]
    advances << double_advance unless moved

    advances.keep_if do |mv|
      on_board?(mv.destination) && !@board.attacking?(position, mv.destination)
    end
    attacks.keep_if do |mv|
      on_board?(mv.destination) && @board.attacking?(position, mv.destination)
    end

    advances + attacks
  end

  def direction
    (color == :black ? 1 : -1)
  end

  def single_advance
    Move.new(position, [position.first + direction, position.last], [])
  end

  def double_advance
    new_move = Move.new

    new_move.start = position
    new_move.destination = [position.first + (2 * direction), position.last]
    new_move.sequence = []
    new_move.sequence << [position.first + direction, position.last]

    new_move
  end

  def attack_right
    Move.new(position, [position.first + direction, position.last + 1], [])
  end

  def attack_left
    Move.new(position, [position.first + direction, position.last - 1], [])
  end

  def on_board?(position)
    position.first.between?(0, 7) && position.last.between?(0, 7)
  end

  def position=(new_position)
    @position = new_position
    @moved = true
  end
end
