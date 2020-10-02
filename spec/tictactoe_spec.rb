# frozen_string_literal: true

require './lib/tictactoe'
require 'stringio'

describe Player do
  it 'checks if name and symbol is stored correctly' do
    player = Player.new('Test', 'X')
    expect(player.name).to eq('Test')
    expect(player.symbol).to eq('X')
  end

  it 'checks for invalid symbol' do
    player = Player.new('Test', 't')
    expect(player.symbol).to eq(nil)
  end

  it 'checks for invalid symbol length' do
    player = Player.new('Test', 'XXX')
    expect(player.symbol).to eq(nil)
  end
end

describe Game do
  before(:each) do
    @game = Game.new
  end
  context '.draw_reference_board' do
    it 'draws reference board correctly' do
      expect { @game.draw_reference_board }.to output("0│1│2\n─┼─┼─\n3│4│5\n─┼─┼─\n6│7│8\n").to_stdout
    end
  end

  context '#draw_game_board' do
    it 'draws game board correctly' do
      @game.instance_variable_set(:@movements, [{ raw_move: 0, x: 0, y: 0, symbol: 'X' },
                                                { raw_move: 3, x: 0, y: 2, symbol: 'O' }])

      expect { @game.draw_game_board }.to output("X│ │ \n─┼─┼─\nO│ │ \n─┼─┼─\n │ │ \n").to_stdout
    end
  end

  context '#get_move' do
    it 'handles non-integers for movement' do
      io = StringIO.new('a')
      $stdin = io
      player = double(Player)
      allow(player).to receive(:name).and_return('Test')
      expect { @game.get_move(player) }.to output('Test, your move (0-8): ').to_stdout.and raise_error(ArgumentError)
      $stdin = STDIN
    end
  end

  context '#handle_move' do
    it 'checks for moves out of range' do
      expect(@game.handle_move(20, 'X')).to be false
    end
    it 'checks if move is already used' do
      @game.instance_variable_set(:@movements, [{ raw_move: 6, x: 0, y: 4, symbol: 'X' }])

      move = 6
      expect(@game.handle_move(move, 'X')).to be false
    end

    it 'adds valid move to @movements' do
      move = 5
      expect(@game.handle_move(move, 'O')).to be true
      expect(@game.instance_variable_get(:@movements).any? { |h| h[:raw_move] == move }).to be true
      expect(@game.instance_variable_get(:@noughts).any? { |h| h[:raw_move] == move }).to be true
      expect(@game.instance_variable_get(:@crosses).any? { |h| h[:raw_move] == move }).to be false
    end

    describe 'handles valid win condition' do
      win_permutations = [[0, 3, 6], [0, 1, 2], [0, 4, 8], [1, 4, 7], [2, 5, 8], [2, 4, 6], [3, 4, 5], [6, 7, 8]]
      win_permutations.each do |perm|
        it "handles #{perm} win permutation" do
          expect(@game.instance_variable_get(:@winner)).to eq nil
          expect(@game.instance_variable_get(:@finished)).to eq false
          perm.each do |move|
            @game.handle_move(move, 'X')
          end
          expect(@game.instance_variable_get(:@winner)).to eq 'X'
          expect(@game.instance_variable_get(:@finished)).to eq true
        end
      end
    end
  end
end
