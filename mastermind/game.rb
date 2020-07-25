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
  attr_reader :game_over
  def initialize
    @code_word = []
    @result_arr = []
    @game_over = false
    @attempts = 12
  end

  def generate_code
    4.times do
      tmp = rand(6)
      @code_word.push(tmp)
    end
    # puts 'Generated:'
    # show_colored_word(@code_word)
    # puts
  end

  def handle_attempt(code_chars)
    return false unless code_chars.length == 4

    code_nums = code_chars.upcase.chars.filter_map do |char|
      number_output(char)
    end
    return false unless code_nums.length == 4

    show_colored_word(code_nums)
    compare_guess_with_code(code_nums)
    true
  end

  private

  def show_colored_word(word)
    word.each do |char|
      color_output(char)
    end
  end

  def find_exact_matches(guess, code_copy)
    3.downto(0) do |i|
      next unless guess[i] == code_copy[i]

      @result_arr.push(6)
      guess.delete_at(i)
      code_copy.delete_at(i)
    end
  end

  def find_rel_matches(guess, code_copy)
    (code_copy.length - 1).downto(0) do |i|
      num_match = code_copy.find_index(guess[i])
      next unless num_match

      @result_arr.push(7)
      guess[i] = nil
      code_copy[num_match] = nil
    end
  end

  def print_result
    print "\t"
    show_colored_word(@result_arr.sort!)
    puts
  end

  def compare_guess_with_code(guess)
    if guess == @code_word
      puts "You've guessed correctly. Game over"
      return @game_over = true
    end
    @result_arr = []
    code_copy = @code_word.dup
    find_exact_matches(guess, code_copy)
    find_rel_matches(guess, code_copy)
    print_result
    # @result_arr = []
    # tmp_answer = @code_word.dup
    # 3.downto(0) do |i|
    #   next unless guess[i] == tmp_answer[i]

    #   @result_arr.push(6)
    #   guess.delete_at(i)
    #   tmp_answer.delete_at(i)
    # end
    # (tmp_answer.length - 1).downto(0) do |i|
    #   num_match = tmp_answer.find_index(guess[i])
    #   next unless num_match

    #   @result_arr.push(7)
    #   guess[i] = nil
    #   tmp_answer[num_match] = nil
    # end
  end
end
