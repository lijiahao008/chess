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
