require_relative 'piece.rb'
require "byebug"

class Board
  attr_accessor :grid

  def initialize(grid = nil)
    @grid ||= Array.new(8) { Array.new(8) }
  end

  def populate
    grid[2..5].map! do |row|
      row.map! do |el|
        el = NullPiece.instance
      end
    end

    self.grid[0] = [Rook.new(self, [0,0], :black),
                      Knight.new(self, [0,1], :black),
                      Bishop.new(self, [0,2], :black),
                      Queen.new(self, [0,3], :black),
                      King.new(self, [0, 4], :black),
                      Bishop.new(self, [0, 5], :black),
                      Knight.new(self, [0, 6], :black),
                      Rook.new(self, [0,7], :black)]

    self.grid[-1] = [Rook.new(self, [7,0], :white),
                      Knight.new(self, [7,1], :white),
                      Bishop.new(self, [7,2], :white),
                      Queen.new(self, [7,3], :white),
                      King.new(self, [7, 4], :white),
                      Bishop.new(self, [7, 5], :white),
                      Knight.new(self, [7, 6], :white),
                      Rook.new(self, [7,7], :white)]

    [1, 6].each do |row|
      color = row == 1 ? :black : :white

      self.grid[row] = 0.upto(7).map do |col|
        Pawn.new(self, [row, col], color)
      end
    end
  end

  def in_check?(current_player_color)
    current_king_pos = find_king_pos(current_player_color)
    opponent_color = (current_player_color == :black ? :white : :black)
    opponent_player_pieces = pieces(opponent_color)
    opponent_player_pieces.each do |opponent_player_piece|
      return true if opponent_player_piece.moves.any? { |pos| current_king_pos == pos }
    end

    false
  end

  # Current player is in checkmate?
  def checkmate?(current_player_color)
    return false unless in_check?(current_player_color)
    current_player_pieces = pieces(current_player_color)
    current_player_pieces.all? { |current_player_piece| current_player_piece.valid_moves.empty? } # !!!!don't trust this
  end

  def find_king_pos(current_player_color)
    grid.flatten.each do |piece|
      return piece.pos if piece.is_a?(King) && piece.color == current_player_color
    end
  end

  def pieces(color)
    pieces = []
    grid.flatten.each do |piece|
      pieces << piece if piece.color == color
    end

    pieces
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, piece)
    row, col = pos
    grid[row][col] = piece
  end

  def move_piece(start_pos, end_pos)
    begin
      raise InvalidStartPosError if self[start_pos].is_a?(NullPiece)
      raise InvalidEndPosError unless in_bounds?(end_pos)
      self[end_pos] = self[start_pos]
      self[start_pos] = NullPiece.instance
      self[end_pos].pos = end_pos
    rescue InvalidStartPosError => e
      puts e.message
    rescue InvalidEndPosError => e
      puts e.message
    end
  end

  def in_bounds?(pos)
    pos.all? { |n| n.between?(0, 7)}
  end

  def deep_dup
    new_grid = Array.new(8) { Array.new(8) }
    new_board = self.class.new(new_grid)
    self.grid.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        new_color = piece.color
        new_pos = [row_index, col_index]
        unless piece.is_a?(NullPiece)
          new_board[new_pos] = piece.class.new(new_board, new_pos, new_color)
        else
          new_board[new_pos] = piece.class.instance
        end
      end

    end
    new_board
  end
end

class InvalidStartPosError < StandardError
  def message
    puts "Invalid start position."
  end
end

class InvalidEndPosError < StandardError
  def message
    puts "Invalid end position."
  end
end
