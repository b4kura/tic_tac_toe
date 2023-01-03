# colorize commands

class String
  def red; colorize(self, "\e[1m\e[31m"); end
  def green; colorize(self, "\e[1m\e[32m"); end
  def purple; colorize(self, "\e[35m"); end
  def yellow; colorize(self, "\e[1m\e[33m"); end
  def bold; colorize(self, "\e[1m"); end
  def colorize(text, color_code) "#{color_code}#{text}\e[0m" end
end

# tic tac toe

class Game
  def initialize
    @initial_board = {a1: '___|',
      a2: '___|',
      a3: '___',
      b1: '___|',
      b2: '___|',
      b3: '___',
      c1: '   |',
      c2: '   |',
      c3: '   '
    }
    @wins = [['a1','a2','a3'], 
             ['a1', 'b1', 'c1'],
             ['a1', 'b2', 'c3'], 
             ['a2', 'b2', 'c2'], 
             ['a3', 'b2', 'c1'],
             ['a3', 'b3', 'c3'],
             ['b1', 'b2', 'b3'], 
             ['c1', 'c2', 'c3']]
    @options = ['x', 'o']
    @board = @initial_board
    @moves_made_by_user = Array.new
    @moves_made_by_computer = Array.new
    @moves_available = @initial_board.keys.map(&:to_s)
    @user_side = ''
    @computer_side = ''
    @who_won = nil
  end

  def make_board
    board = "   1   2   3\n"
    ('a'..'c').each do |letter|
      line = ''
      1..3.times do |n|
        line << "#{@board["#{letter}#{n+1}".to_sym]}" 
      end
      board << "#{letter} #{line}\n".bold
    end
    board
  end

  def upgrade_board(letter, place)
    @board[place.to_sym] = @board[place.to_sym].split('').map.with_index { |el,index| index == 1 ? letter : el }.join
    make_board
  end

  def make_random_move(moves_available)
    moves_available[rand(moves_available.size).to_i]
  end

  def show_initial_screen
    puts 'welcome to my tic tac toe game!'.green.bold
    puts make_board
    puts 'first, choose a side! [x/o]'
    @user_side = gets.chomp
    @program_side = @options.reject { |opt| opt == @user_side }.join
  end

  def buffer
    line = ''
    0...4.times do |i|
      line = '.'.bold*i
      print "#{line}\r"
      sleep(0.5)
      print ("\e[K")
    end
    print "\n"
  end
      
  
  def play(who)
    if @user_side == who
      puts 'make a move!'.purple
      move = gets.chomp
      new_board = upgrade_board(@user_side, move)
      @moves_available.reject!{|c| c == move}
      @moves_made_by_user << move
      puts new_board
    else
      puts 'my turn. lemme think...'.green.bold
      buffer
      move = make_random_move(@moves_available)
      new_board = upgrade_board(@program_side, move)
      @moves_made_by_computer << move
      @moves_available.reject!{|c| c == move}
      puts new_board
    end
  end
   
  def start
    show_initial_screen
    who_plays = @options[rand(@options.size).to_i]
    puts 'let\'s roll the dice...'.purple.bold
    buffer
    puts "#{who_plays} starts.".purple.bold
    while !someone_won? && @moves_available.size > 0 do
      play(who_plays)
      who_plays = @options.reject{|el| el == who_plays}.join
    end
    puts @who_won == 'user' ? "you won the game!".yellow : @who_won == 'computer' ? 'looks like i won this time HA'.red : "it's a tie!".green
  end

  def someone_won?
    @wins.each do |win_streak|
      found_moves_computer = win_streak.select { |move| @moves_made_by_computer.include?(move) }
      found_moves_user = win_streak.select { |move| @moves_made_by_user.include?(move) }
      if found_moves_computer.size == win_streak.size
        @who_won = 'computer'
        return true
      elsif found_moves_user.size == win_streak.size
        @who_won = 'user'
        return true
      end
    end
    return false
  end
end

game = Game.new
game.start
