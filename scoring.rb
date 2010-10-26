module Tetris
  class Scoring
    attr_reader :score, :level, :lines_cleared

    LineClearMultipliers = { 1 => 40, 2 => 100, 3 => 300, 4 => 1200 }
    LinesPerLevel = 10

    def initialize(window)
      @window = window
      @score = 0
      @level = 0
      @lines_cleared = 0
    end

    def line_clear(rows)
      @score += LineClearMultipliers[rows] * (level+1)
      @lines_cleared += rows
      @level = @lines_cleared/LinesPerLevel
    end
  end
end
