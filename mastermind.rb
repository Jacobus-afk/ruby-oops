# frozen_string_literal: true

# https://stackoverflow.com/questions/1489183/colorized-ruby-output-to-the-terminal
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def cyan
    colorize(36)
  end
end

# collection of board stuff
module Board
  # colorization
  COLORWORDS = %w[R G Y B P C].freeze
  COLORMETHODS = %i[red green yellow blue pink cyan].freeze

  def color_output(number)
    print '*'.send(COLORMETHODS[number])
  end
end

# mastermind game class
class Game
  include Board
  def initialize
    @code_word = []
  end

  def generate_code
    4.times do
      tmp = rand(6)
      @code_word.push(tmp)
      #   color_output(tmp)
    end
    show_colored_word(@code_word)
    # puts @code_word
  end

  def show_colored_word(word)
    word.each do |char|
      color_output(char)
    end
    puts
  end
end

# puts 'test'.red
game = Game.new
game.generate_code
