# frozen_string_literal: true

require_relative 'mastermind/game.rb'

mode = nil

until %w[G C].include? mode
  print 'creator or guesser (G/C)? '
  mode = gets[0].upcase
end

game = Game.new(mode)
game.generate_code

until game.game_over_msg
  # print 'your guess (R,G,B,Y,P,C): '
  # code = gets.chomp
  game.generate_guess
end
puts game.game_over_msg
