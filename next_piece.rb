require "tetrominos"
require "tetromino_renderer"

module Tetris
  class NextPiece
    include TetrominoRenderer
    
    def initialize(window, random_generator)
      @window = window
      @random_generator = random_generator
      @rotation = 0
    end
    
    def draw
      @shape = @random_generator.peek
      draw_at(400, 50)
    end
  end
end
