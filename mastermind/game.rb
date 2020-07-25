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

# class for creator mode
class CreatorGame
  def initialize; end
end

# class for guesser mode
class GuesserGame
  include Board

  def generate_code(code_word)
    4.times do
      tmp = rand(6)
      code_word.push(tmp)
    end
    # puts 'Generated:'
    # show_colored_word(@code_word)
    # puts
  end

  def guess_prompt
    loop do
      print 'your guess (R,G,B,Y,P,C): '
      code_chars = gets.chomp.upcase.chars
      return code_chars if code_chars.length == 4

      puts 'Invalid size (must be 4 letters)'
    end
  end

  def generate_guess
    loop do
      code_nums = guess_prompt.filter_map do |char|
        number_output(char)
      end
      return code_nums if code_nums.length == 4

      puts 'Invalid character in attempt'
    end
  end

  def handle_guess(guess, code_word, attempts, result_arr)
    return "You've guessed correctly. Game over" if guess == code_word

    return "You've run out of turns. Game over" if attempts.zero?

    code_copy = code_word.dup
    find_exact_matches(guess, code_copy, result_arr)
    find_rel_matches(guess, code_copy, result_arr)
    nil
  end

  def find_exact_matches(guess, code_copy, result_arr)
    3.downto(0) do |i|
      next unless guess[i] == code_copy[i]

      result_arr.push(6)
      guess.delete_at(i)
      code_copy.delete_at(i)
    end
  end

  def find_rel_matches(guess, code_copy, result_arr)
    (code_copy.length - 1).downto(0) do |i|
      num_match = code_copy.find_index(guess[i])
      next unless num_match

      result_arr.push(7)
      guess[i] = nil
      code_copy[num_match] = nil
    end
  end
end

# game class wrapper
class Game
  include Board
  CREATOR = 'C'
  GUESSER = 'G'
  attr_reader :mode, :game_over_msg
  def initialize(mode)
    @mode = GuesserGame.new if mode == GUESSER
    @guess_word = []
    @code_word = []
    @result_arr = []
    @game_over_msg = nil
    @attempts = 12
  end

  def generate_code
    mode.generate_code(@code_word)
  end

  def generate_guess
    @guess_word = mode.generate_guess
    show_colored_word(@guess_word)
    @result_arr = []
    @attempts -= 1
    @game_over_msg = mode.handle_guess(@guess_word, @code_word, @attempts, @result_arr)
    print_attempt_resp
  end

  private

  def show_colored_word(word)
    word.each do |char|
      color_output(char)
    end
  end

  def print_attempt_resp
    print "\t"
    show_colored_word(@result_arr.sort!)
    puts
  end
end
