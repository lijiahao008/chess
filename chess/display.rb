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

  def render
    board.grid.each_with_index do |row, row_index|
      row.each_with_index do |el, col_index|
        background = (row_index + col_index).odd? ? :white : :grey
        if [row_index, col_index] == cursor.cursor_pos
          print (" " + board[cursor.cursor_pos].symbol + " ").colorize(:background => :light_green)
        else
          print (" " + el.symbol + " ").colorize(:background => background)
        end
      end
      puts ""
    end
    puts ""
  end
end
