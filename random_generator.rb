module Tetris
  class RandomGenerator
    def initialize
      srand
      @bag = []
    end
    
    def fill_bag
      @bag.insert 0, *[:I, :J, :L, :O, :S, :T, :Z].shuffle
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