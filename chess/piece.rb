require 'singleton'
require 'byebug'
module Stepable

  def moves
    result = []
    move_diffs.each do |dx, dy|
      new_x, new_y = pos
      new_x, new_y = new_x + dx, new_y + dy
      new_pos = [new_x, new_y]

      next unless board.in_bounds?(new_pos)

      if board[new_pos].is_a?(NullPiece)
        result << new_pos
      else
        result << new_pos if board[new_pos].color != color
      end
    end

    result
  end

  private
  def move_diffs
    # implemented by class which is including this module
    raise "Method is not implemented"
  end
end

module Slideable
  def moves
    result = []
    move_dirs.each do |x, y|
      result += grow_unblocked_moves_in_dir(x, y)
    end

    result
  end

  private
  def move_dirs
    raise "Method is not implemented"
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
      new_pos = [new_x, new_y]

      break unless board.in_bounds?(new_pos)

      if board[new_pos].is_a?(NullPiece)
        moves << new_pos
      else
        moves << new_pos if board[new_pos].color != color
        break
      end
    end

    moves
  end
end

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
