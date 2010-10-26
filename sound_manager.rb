module Tetris
  class SoundManager
    def initialize(window)
      @window = window
      @samples = {}
      load_samples
    end

    def play(sample)
      @samples[sample].play
    end

    def load_sample(name, filename)
      @samples[name] = Gosu::Sample.new(@window, "sfx/#{filename}")
    end

    def load_samples
      load_sample(:explosion1, "97403__phisto99__Untitled_017_Explosion.aif")
      load_sample(:explosion2, "97422__phisto99__Untitled_038_Explosion.aif")
      load_sample(:fx1, "32955__HardPCM__Chip055.wav")
      load_sample(:fx2, "31870__HardPCM__Chip033.wav")
    end
  end
end
