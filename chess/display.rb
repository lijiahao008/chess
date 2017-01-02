require_relative 'board.rb'
require 'colorize'
require 'byebug'
require_relative 'cursor.rb'

class Display
  attr_reader :cursor, :board

  def initialize(board)
    @cursor = Cursor.new([7,7], board)
    @board = board
  end

  def test
    10.times do
      cursor.get_input
      render

    end
  end

  def render
    board.grid.each_with_index do |row, row_index|
      row.each_with_index do |el, col_index|
        print board[cursor.cursor_pos].symbol.to_s.colorize(:blue) if [row_index, col_index] == cursor.cursor_pos
        print el.symbol.to_s + " "
      end
      puts ""
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.populate
  d = Display.new(b)
  d.test
end
