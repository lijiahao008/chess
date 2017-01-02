require_relative 'piece.rb'

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
  end

  def populate

    grid[2..5].map! do |row|
      row.map! do |el|
        el = NullPiece.instance
      end
    end

    self.grid[0] = [Rook.new(grid, [0,0], :black),
                      Knight.new(grid, [0,1], :black),
                      Bishop.new(grid, [0,2], :black),
                      Queen.new(grid, [0,3], :black),
                      King.new(grid, [0, 4], :black),
                      Bishop.new(grid, [0, 5], :black),
                      Knight.new(grid, [0, 6], :black),
                      Rook.new(grid, [0,7], :black)]

    self.grid[-1] = [Rook.new(grid, [7,0], :white),
                      Knight.new(grid, [7,1], :white),
                      Bishop.new(grid, [7,2], :white),
                      Queen.new(grid, [7,3], :white),
                      King.new(grid, [7, 4], :white),
                      Bishop.new(grid, [7, 5], :white),
                      Knight.new(grid, [7, 6], :white),
                      Rook.new(grid, [7,7], :white)]

    self.grid[1] = [Pawn.new(grid, [1,0], :black),
                      Pawn.new(grid, [1,1], :black),
                      Pawn.new(grid, [1,2], :black),
                      Pawn.new(grid, [1,3], :black),
                      Pawn.new(grid, [1, 4], :black),
                      Pawn.new(grid, [1, 5], :black),
                      Pawn.new(grid, [1, 6], :black),
                      Pawn.new(grid, [1,7], :black)]

    self.grid[-2] = [Pawn.new(grid, [6,0], :white),
                      Pawn.new(grid, [6,1], :white),
                      Pawn.new(grid, [6,2], :white),
                      Pawn.new(grid, [6,3], :white),
                      Pawn.new(grid, [6, 4], :white),
                      Pawn.new(grid, [6, 5], :white),
                      Pawn.new(grid, [6, 6], :white),
                      Pawn.new(grid, [6, 7], :white)]
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
      # self[end_pos].pos = end_pos
    rescue InvalidStartPosError => e
      puts e.message
    rescue InvalidEndPosError => e
      puts e.message
    end
  end

  def in_bounds?(pos)
    pos.all? { |n| n.between?(0, 7)}
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
