require 'singleton'
require_relative 'slideable'
require_relative 'stepable'

class Piece
  attr_reader :board, :color, :symbol
  attr_accessor :pos

  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @symbol = nil
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end

  def move_into_check?(end_pos)
    new_board = board.deep_dup
    new_board.move_piece(pos, end_pos)
    new_board.in_check?(color)
  end
end

class NullPiece < Piece
  include Singleton
  attr_reader :symbol, :color

  def initialize
    @symbol = " "
    @color = :clear
  end
end

class Bishop < Piece
  include Slideable
  attr_reader :symbol

  def initialize(board, pos, color)
    super(board, pos, color)
    @symbol = color == :black ? "♝" : "♗"
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
    @symbol = color == :black ? "♜" : "♖"
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
    @symbol = color == :black ? "♛" : "♕"
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
    @symbol = color == :black ? "♞" : "♘"
  end

  protected
  def move_diffs
    [ [-2, -1],
      [-2,  1],
      [-1, -2],
      [-1,  2],
      [ 1, -2],
      [ 1,  2],
      [ 2, -1],
      [ 2,  1]
    ]
  end
end

class King < Piece
  include Stepable
  attr_reader :symbol

  def initialize(board, pos, color)
    super(board, pos, color)
    @symbol = color == :black ? "♚" : "♔"
  end

  protected
  def move_diffs
    [ [-1, -1],
      [-1,  0],
      [-1,  1],
      [ 0,  1],
      [ 1,  1],
      [ 1,  0],
      [ 1, -1],
      [ 0, -1]
    ]
  end
end

class Pawn < Piece
  attr_reader :symbol

  def initialize(board, pos, color)
    super(board, pos, color)
    @symbol = color == :black ? "♟" : "♙"
  end

  def moves
    result = []
    side_attacks.each do |dx, dy|
      new_pos = [pos[0] + dx, pos[1] + dy]
      next unless board.in_bounds?(new_pos)
      opponent_color = (color == :white ? :black : :white)
      result << new_pos if board[new_pos].color == opponent_color
    end

    (1..forward_steps).each do |i|
      new_pos = [pos[0] + (forward_dir * i), pos[1]]
      next unless board.in_bounds?(new_pos)
      result << new_pos if board[new_pos].is_a?(NullPiece)
    end

    result
  end

  def at_start_row?
    (color == :black && pos[0] == 1) || (color == :white && pos[0] == 6)
  end

  def forward_dir
    color == :black ? 1 : -1
  end

  def forward_steps
    at_start_row? ? 2 : 1
  end

  def side_attacks
    if color == :black
      [[1, -1], [1, 1]]
    else
      [[-1, -1], [-1, 1]]
    end
  end
end

class MoveDiffsError < StandardError
end
