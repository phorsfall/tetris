$: << "."
require "rubygems"
require "gosu"
require "input_handler"
require "tetromino"
require "play_field"
require "random_generator"
require "next_piece"
require "scoring"
require "sound_manager"

class Gosu::Color
  PURPLE = Gosu::Color.new(0xffff00ff)
  ORANGE = Gosu::Color.new(0xffff9900)
end

class GameWindow < Gosu::Window
  def initialize
    super(800, 640, false)
    self.caption = "Tetris"
    @game_over = false
    @frame = 0
    @scoring = Tetris::Scoring.new(self)
    @sound_manager = Tetris::SoundManager.new(self)
    @random_generator = Tetris::RandomGenerator.new
    @play_field = Tetris::PlayField.new(self, @scoring)
    @tetromino = Tetris::Tetromino.new(self, @play_field, @random_generator)
    @next_piece = Tetris::NextPiece.new(self, @random_generator)
    @input_handler = InputHandler.new(self, @tetromino)
    @font = Gosu::Font.new(self, "Cracked", 40)
  end
  
  def update
    return if game_over?
    @frame += 1
    @play_field.update

    unless @play_field.clearing_lines?
      # Movement is jerky if a move under gravity happens while soft dropping.
      # Not sure if gravity is supposed to be applied while soft dropping.
      @tetromino.move_down if @frame % gravity == 0
      @input_handler.update
    end
  end

  def draw
    @play_field.draw
    @tetromino.draw
    @next_piece.draw
    @font.draw "Score: #{@scoring.score}", 400, 180, 0
    @font.draw "Level: #{@scoring.level}", 400, 220, 0
    @font.draw "Lines: #{@scoring.lines_cleared}", 400, 260, 0
    @font.draw "Game Over", 200, 200, 0, 4, 4 if game_over?
  end

  def gravity
    # Based on the NES version of the game.
    # http://tetris.wikia.com/wiki/Tetris_(NES,_Nintendo)
    case @scoring.level
    when 0..7
      48 - (@scoring.level * 5)
    when 8
      8
    when 9
      6
    when 10..12
      5
    when 13..15
      4
    when 16..18
      4
    when 19..28
      2
    else
      1
    end
  end

  def game_over!
    @game_over = true
    play_sample :fx2
  end

  def game_over?
    @game_over
  end

  def draw_square(x, y, c, size)
    draw_quad x, y, c, x+size, y, c, x+size, y+size, c, x, y+size, c
  end

  def play_sample(name)
    @sound_manager.play(name)
  end

  def button_down(id)
    @input_handler.button_down(id) unless @play_field.clearing_lines?
    close if id == Gosu::Button::KbEscape
  end
end

window = GameWindow.new
window.show
