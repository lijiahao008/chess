require 'singleton'

module Stepable

  def moves
    result = []
    move_diffs.each do |x, y|

    end
    result
  end

  private
  def move_diffs
  end
end

module Slideable
  def moves
    result = []
    move_dirs.each do |x, y|
      result + grow_unblocked_moves_in_dir(x, y)
    end

    result
  end

  private
  def move_dirs

  end

  def horizontal_dirs
    [[-1, 0], [0, -1], [0, 1], [1, 0]]
  end

  def diagonal_dirs
    [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  end

  def grow_unblocked_moves_in_dir(dx, dy)
    new_x, new_y = pos
    moves = []
    while true
      new_x, new_y = new_x + dx, new_y + dy
      pos = [cur_x, cur_y]

      break unless board.valid_pos?(pos)

      if board[pos].is_a?(NullPiece)
        moves << pos
      else
        moves << pos if board[pos].color != color
        break
      end
    end
    moves
  end
end

class Piece
  attr_reader :board, :pos, :color, :symbol

  def initialize(board, pos, color)
    # @name = name
    @board = board
    @pos = pos
    @color = color
    @symbol = nil
  end
end

class NullPiece < Piece
  include Singleton
  attr_reader :symbol

  def initialize
    @symbol = :nullpiece
  end
end

class Bishop < Piece
  include Slideable
  attr_reader :symbol

  def initialize(board, pos, color)
    super(board, pos, color)
    @symbol = :bishop
  end

  def move_dirs
    diagonal_dirs
  end

end

class Rook < Piece
  include Slideable
  attr_reader :symbol

  def initialize(board, pos, color)
    super(board, pos, color)
    @symbol = :rook
  end

  def move_dirs
    horizontal_dirs
  end
end

class Queen < Piece
  include Slideable
  attr_reader :symbol

  def initialize(board, pos, color)
    super(board, pos, color)
    @symbol = :queen
  end

  def move_dirs
    horizontal_dirs + diagonal_dirs
  end
end

class Knight < Piece
  include Stepable
  attr_reader :symbol

  def initialize(board, pos, color)
    super(board, pos, color)
    @symbol = :knight
  end
end

class King < Piece
  include Stepable
  attr_reader :symbol

  def initialize(board, pos, color)
    super(board, pos, color)
    @symbol = :king
  end
end

class Pawn < Piece
  attr_reader :symbol

  def initialize(board, pos, color)
    super(board, pos, color)
    @symbol = :pawn
  end
end
