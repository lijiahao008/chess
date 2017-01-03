require_relative 'board'
require_relative 'player'

class Chess
  attr_reader :player1, :player2, :board
  attr_accessor :current_player

  def initialize(player1, player2, board)
    @player1 = player1
    @player2 = player2
    @current_player = player1
    @board = board
    board.populate
  end

  def play
    until game_over?
      current_player.play_turn
      swap_turn!
    end
    puts "Game Over."
    puts "Loser: #{current_player.color}"
    current_player.display.render
  end

  private

  def game_over?
    board.checkmate?(player1.color) || board.checkmate?(player2.color)
  end

  def swap_turn!
    self.current_player = (current_player == player1 ? player2 : player1)
  end
end

if __FILE__ == $PROGRAM_NAME
  system('clear')
  board = Board.new
  player1 = HumanPlayer.new("Player1", :white, board)
  player2 = HumanPlayer.new("Player2", :black, board)
  game = Chess.new(player1, player2, board)
  game.play
end
