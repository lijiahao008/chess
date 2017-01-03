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
