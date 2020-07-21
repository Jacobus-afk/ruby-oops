# frozen_string_literal: true

# descriptive comment
module Board
  BOARDPLAYABLE = ' │ │ '
  BOARDSTRUCTURE = '─┼─┼─'

  def generate_board
    [BOARDPLAYABLE.dup, BOARDSTRUCTURE.dup, BOARDPLAYABLE.dup, BOARDSTRUCTURE.dup, BOARDPLAYABLE.dup]
  end

  def win_permutations
    [[0, 3, 6], [0, 1, 2], [0, 4, 8], [1, 4, 7], [2, 5, 8], [2, 4, 6], [3, 4, 5], [6, 7, 8]]
  end
end

# holds game info
class Game
  include Board
  attr_reader :finished, :winner
  def initialize(players)
    @finished = false
    @noughts = []
    @crosses = []
    @movements = []
    @players = players
    @winner = nil
  end

  def draw_reference_board
    tmpboard = generate_board
    t = 0
    (0..4).step(2).each do |i|
      (0..4).step(2).each do |j|
        tmpboard[i][j] = t.to_s
        t += 1
      end
    end
    puts tmpboard
  end

  def draw_game_board
    tmpboard = generate_board
    @movements.each do |move|
      tmpboard[move[:y]][move[:x]] = move[:symbol]
    end
    puts tmpboard
  end

  def handle_move(move, symbol)
    return false if @movements.any? { |h| h[:raw_move] == move }

    y_coord = (move / 3) * 2
    x_coord = (move % 3) * 2
    movement = { raw_move: move, x: x_coord, y: y_coord, symbol: symbol }
    @movements.push(movement)

    symbol_obj = symbol == 'X' ? @crosses : @noughts
    symbol_obj.push(movement)
    test_for_win(symbol_obj, symbol)
    true
  end

  private

  def test_for_win(symbolset, symbol)
    move_map = symbolset.map do |entry|
      entry[:raw_move]
    end
    match = win_permutations.filter do |permutation|
      (permutation & move_map).length == 3
    end
    return if match.empty?

    @finished = true
    @winner = symbol
  end
end

# holds info about player
class Player
  attr_reader :name, :symbol
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

players = [Player.new('Player 1', 'X'), Player.new('Player 2', 'O')]
game = Game.new(players)

until game.finished
  players.each do |player|
    begin
      system('cls') || system('clear')
      puts 'Reference:'
      game.draw_reference_board
      puts 'Game board:'
      game.draw_game_board
      print "#{player.name}, your move (0-9): "
      move = Integer(gets.chomp)
      raise unless game.handle_move(move, player.symbol)
    rescue StandardError
      puts 'Invalid option'
      retry
    end
    if game.winner
      puts "#{player.name} won!"
      break
    end
  end
end
