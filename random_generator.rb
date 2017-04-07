module Tetris
  class RandomGenerator
    def initialize
      @bag = []
    end

    def fill_bag
      @bag.unshift(*Tetris::TetrominoRenderer::COLORS.keys.shuffle)
    end

    def next_shape
      fill_bag if @bag.count < 2
      @bag.pop
    end

    def peek
      @bag.last
    end
  end
end