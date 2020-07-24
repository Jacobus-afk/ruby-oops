# frozen_string_literal: true

# https://stackoverflow.com/questions/1489183/colorized-ruby-output-to-the-terminal
class String
  def colorize(color_code)
    "\e[1;#{color_code}m#{self}\e[0m"
  end

  def black
    colorize(30)
  end

  def white
    colorize(37)
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
  COLORWORDS = %w[R G Y B P C].freeze
  COLORMETHODS = %i[red green yellow blue pink cyan black white].freeze

  def color_output(number)
    print '█ '.send(COLORMETHODS[number])
  end

  def number_output(char)
    COLORWORDS.find_index(char)
  end
end

# mastermind game class
class Game
  include Board
  def initialize
    @code_word = []
    @result_arr = []
  end

  def generate_code
    4.times do
      tmp = rand(6)
      @code_word.push(tmp)
    end
    puts 'Generated:'
    show_colored_word(@code_word)
  end

  def handle_attempt(code_chars)
    return false unless code_chars.length == 4

    code_nums = code_chars.upcase.chars.filter_map do |char|
      number_output(char)
    end
    return false unless code_nums.length == 4

    show_colored_word(code_nums)
    check_validity(code_nums)
    true
  end

  private

  def show_colored_word(word)
    word.each do |char|
      color_output(char)
    end
    puts
  end

  def check_validity(guess)
    @result_arr = []
    tmp_answer = @code_word.dup
    3.downto(0) do |i|
      if guess[i] == tmp_answer[i]
        @result_arr.push(6)
        guess[i] = nil
        tmp_answer[i] = nil
        # guess.delete_at(i)
        # tmp_answer.delete_at(i)
      else
        num_match = tmp_answer.find_index(guess[i])
        if num_match
          @result_arr.push(7)
          guess[i] = nil
          tmp_answer[num_match] = nil
          # guess.delete_at(num_match)
          # tmp_answer.delete_at(i)
        end
      end
    end
    show_colored_word(@result_arr.sort!)

    # tmp.delete_at(1)
    # puts
    # compare guess with code_word
    # create copy of code_word
    # empty result_hash
    # if guess position matches add black to result_hash, remove entry from code_word and guess
    # else if color is elsewhere in code_word add white to result_hash remove entry from code_word and guess
  end
end

# puts 'test'.red
game = Game.new
game.generate_code

loop do
  print 'your guess (R,G,B,Y,P,C): '
  code = gets.chomp
  puts 'Invalid attempt' unless game.handle_attempt(code)
end
