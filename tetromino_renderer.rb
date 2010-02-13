module Tetris
  module TetrominoRenderer
    Colors = {
      :I => :cyan,
      :J => :blue,
      :L => :orange,
      :O => :yellow,
      :S => :green,
      :T => :purple,
      :Z => :red
    }
    
    # HACK: This is used directly by Tetromino for non-drawing related tasks. Should probably be elsewhere.
    def each_block
      0.upto(3) do |x|
        0.upto(3) do |y|
          # TODO: Move the bitwise and into #rotation.
          # Not sure now there's a rotate method for each direction.
          c = Tetrominos[@shape][@rotation & 3][y][x]
          yield x, y, c if c == 1
        end
      end
    end
    
    def draw_at(x, y)
      each_block do |bx, by, bc|
        wx = bx * PlayField::CellSize + x
        wy = by * PlayField::CellSize + y
        c = Gosu::Color.const_get Colors[@shape].to_s.upcase
        @window.draw_square wx, wy, c, PlayField::CellSize - 1
      end
    end
  end
end