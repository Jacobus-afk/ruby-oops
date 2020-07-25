# frozen_string_literal: true

require_relative 'mastermind/game.rb'

game = Game.new
game.generate_code

until game.game_over == true
  print 'your guess (R,G,B,Y,P,C): '
  code = gets.chomp
  puts 'Invalid attempt' unless game.handle_attempt(code)
end
