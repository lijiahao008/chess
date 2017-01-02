require 'singleton'

module Stepable
  DELTAS = [ [ ] ]

  def moves(move_dirs)
  end

  # private
  # def move_diffs
  # end
end

module Slideable
  def moves(move_dirs)
    result = []
    move_dirs.each do |dir|
      if dir == :diagonal
        i = pos[0]
        while i < 8
          result << [pos[0] + i, pos[1] + i]
        end
      end

    result
  end

  # private
  # def move_dirs
  # end

  def horizontal_dirs
  end

  def diagonal_dirs
  end

  def grow_unblocked_moves_in_dir(dx, dy)
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
    [:diagonal]
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
    [:horizontal, :vertical]
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
    [:horizontal, :vertical, :diagonal]
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

module Stepable
  def moves(move_dirs)
  end

  # private
  # def move_diffs
  # end
end

module Slideable
  def move(move_dirs)
  end

  # private
  # def move_dirs
  # end

  def horizontal_dirs
  end

  def diagonal_dirs
  end

  def grow_unblocked_moves_in_dir(dx, dy)
  end
end
