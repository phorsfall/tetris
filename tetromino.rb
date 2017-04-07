require "tetrominos"
require "tetromino_renderer"

module Tetris
  class Tetromino
    include TetrominoRenderer

    def initialize(window, play_field, random_generator)
      @window = window
      @play_field = play_field
      @random_generator = random_generator
      spawn
    end

    def rotate_clockwise
      attempt_move(0, 0, 1)
    end

    def rotate_counter_clockwise
      attempt_move(0, 0, -1)
    end

    def move_down
      unless attempt_move(0, 1, 0)
        lock
        spawn
      end
    end

    def move_left
      attempt_move(-1, 0, 0)
    end

    def move_right
      attempt_move(1, 0, 0)
    end

    def attempt_move(x, y, rotation)
      @x += x
      @y += y
      @rotation += rotation

      if fits_play_field?
        true
      else
        @x -= x
        @y -= y
        @rotation -= rotation
        false
      end
    end

    def lock
      each_block do |bx, by, bc|
        col, row = @x + bx, @y + by
        @play_field.cells[row][col] = 1
      end
      @window.play_sample :explosion1
    end

    def spawn
      @shape = @random_generator.next_shape
      @x = 3
      @y = @rotation = 0
      @window.game_over! unless fits_play_field?
    end

    def fits_play_field?
      each_block do |bx, by, bc|
        col, row = @x + bx, @y + by
        return false if outside_walls?(col) || through_floor?(row) || overlapping?(row, col)
      end
      true
    end

    def outside_walls?(column)
      column < 0 || column >= PlayField::Columns
    end

    def through_floor?(row)
      row >= PlayField::Rows
    end

    def overlapping?(row, column)
      @play_field.cells[row][column]
    end

    def draw
      draw_at @x * PlayField::CellSize, @y * PlayField::CellSize
    end
  end
end
