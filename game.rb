$: << "."
require "rubygems"
require "gosu"
require "input_handler"
require "tetromino"
require "play_field"
require "random_generator"
require "next_piece"

class Gosu::Color
  PURPLE = Gosu::Color.new(0xffff00ff)
  ORANGE = Gosu::Color.new(0xffff9900)
end

class GameWindow < Gosu::Window
  def initialize
    super(800, 640, false)
    self.caption = "Tetris"
    @frame = 0
    @random_generator = Tetris::RandomGenerator.new
    @play_field = Tetris::PlayField.new(self)
    @tetromino = Tetris::Tetromino.new(self, @play_field, @random_generator)
    @next_piece = Tetris::NextPiece.new(self, @random_generator)
    @input_handler = InputHandler.new(self, @tetromino)
    @font = Gosu::Font.new(self, "Cracked", 40)
  end
  
  def update
    @frame += 1
    @play_field.update

    unless @play_field.clearing_lines?
      # Movement is jerky if a move under gravity happens while soft dropping.
      # Not sure if gravity is supposed to be applied while soft dropping.
      @tetromino.move_down if @frame % 48 == 0
      @input_handler.update
    end
  end

  def draw
    @play_field.draw
    @tetromino.draw
    @next_piece.draw
  end
  
  def draw_square(x, y, c, size)
    draw_quad x, y, c, x+size, y, c, x+size, y+size, c, x, y+size, c
  end
  
  def button_down(id)
    @input_handler.button_down(id)
    close if id == Gosu::Button::KbEscape
  end
end

window = GameWindow.new
window.show
