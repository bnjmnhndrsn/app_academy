module ChessConstants
  SKINS = {
    :white => {
      King => "\u2654",
      Queen => "\u2655",
      Rook => "\u2656",
      Bishop => "\u2657",
      Knight => "\u2658",
      Pawn => "\u2659"
    },
    :black => {
      King => "\u265A",
      Queen => "\u265B",
      Rook => "\u265C",
      Bishop => "\u265D",
      Knight => "\u265E",
      Pawn => "\u265F"
    },
    nil => 'X'
  }

  DEFAULT_BOARD = {
    Queen => { white: [[7, 3]], black: [[0, 3]] },
    Pawn => {
      white: [
        [6, 0], [6, 1], [6, 2], [6, 3],
        [6, 4], [6, 5], [6, 6], [6, 7]
      ],
      black: [
        [1, 0], [1, 1], [1, 2], [1, 3],
        [1, 4], [1, 5], [1, 6], [1, 7]
      ]
    },
    Rook => { white: [[7, 0], [7, 7]], black: [[0, 0], [0, 7]] },
    King => { white: [[7, 4]], black: [[0, 4]] },
    Knight => { white: [[7, 1], [7, 6]], black: [[0, 1], [0, 6]] },
    Bishop => { white: [[7, 2], [7, 5]], black: [[0, 2], [0, 5]] }
  }

  DIAGONALS = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
  STRAIGHTS = [[1, 0], [0, 1], [-1, 0], [0, -1]]
end
