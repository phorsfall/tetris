class InputHandler
  def initialize(window, tetromino)
    @window = window
    @tetromino = tetromino
    @das_counter = 0
    @das_direction = nil
    @das_delay = 16
    @das_repeat = 6
    @soft_drop_counter = 0
    @soft_drop_repeat = 2
  end
  
  def button_down(id)
    case id
    when Gosu::Button::KbZ
      @tetromino.rotate_counter_clockwise
    when Gosu::Button::KbX
      @tetromino.rotate_clockwise
    end
  end
  
  def button_down?(id)
    @window.button_down?(id)
  end
  
  def input_left?
    button_down? Gosu::Button::KbLeft
  end
  
  def input_right?
    button_down? Gosu::Button::KbRight
  end
  
  def input_down?
    button_down? Gosu::Button::KbDown
  end
  
  def update
    if input_right?
      @das_counter = @das_direction == :right ? @das_counter + 1 : 0
      @das_direction = :right
    end
    
    if input_left?
      @das_counter = @das_direction == :left ? @das_counter + 1 : 0
      @das_direction = :left
    end
    
    # If we don't set @das_direction to nil when both left and right and pressed
    # the piece would move left quickly, as @das_direction would be set to :left each
    # frame, and @das_counter would be reset to 0 each frame as input_right? is true
    # but @das_direction is :left.
    #
    # Setting it to nil when neither is pressed ensure movement stops when keys are
    # released, otherwise the piece would continue to move if we happended to release
    # the key on a frame which causes movement.
    @das_direction = nil unless input_left? ^ input_right?
    
    if @das_counter == 0 || @das_counter > @das_delay && (@das_counter - @das_delay) % @das_repeat == 0
      # Lots of code is mapping between :right/input_right?/Gosu::Button::KbRight etc.
      # If we put that in a lookup table we'll simplify things.
      @tetromino.move_right if @das_direction == :right
      @tetromino.move_left  if @das_direction == :left
    end
    
    if input_down?
      @tetromino.move_down if @soft_drop_counter % @soft_drop_repeat == 0
      @soft_drop_counter += 1
    else
      @soft_drop_counter = 0
    end
  end
end
