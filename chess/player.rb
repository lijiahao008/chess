require_relative 'cursor'
require_relative 'display'

class Player
  attr_reader :name, :color, :board

  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
    @display = Display.new(board)
  end
end


class HumanPlayer < Player
  def play_turn
    puts "current_player: #{color}"
    @display.render
    start_pos = get_pos
    until valid_start_pos?(start_pos)
      start_pos = get_pos
    end
    puts start_pos.to_s
    end_pos = get_pos
    until valid_end_pos?(start_pos, end_pos)
      end_pos = get_pos
    end

    board.move_piece(start_pos, end_pos)
    system('clear')
  end

  def valid_start_pos?(start_pos)
    result = board[start_pos].color == color && !board[start_pos].valid_moves.empty?
    puts "Cannot start here." unless result
    result
  end

  def valid_end_pos?(start_pos, end_pos)
    result = board[start_pos].valid_moves.include?(end_pos)
    puts "Cannot end here." unless result
    result
  end

  def get_pos
    pos = nil
    loop do
      pos = @display.cursor.get_input
      system('clear')
      puts "current_player: #{color}"
      @display.render
      break unless pos.nil?
    end

    pos
  end
end
