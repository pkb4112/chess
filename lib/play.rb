require_relative "player"
require_relative "game_board"
require_relative "game_piece"


def get_input(player_ID,gameboard)
  begin
    puts "Player #{player_ID}: Please input the location of the piece you would like to move (ex. 'a3'), or enter 'Save' to save and exit"
    input = gets.chomp
    letter = input.match(/(^[a-zA-Z])/)[0].downcase
    col = letter_to_col(letter)
    row = input.match(/(\d$)/)[0].to_i
    square = [col,row]
    return square
  rescue
    puts "Invalid Input!"
    puts ""
  end
end

def verify_input(player_ID,gameboard)
  square = false
  until gameboard.ownership?(square,player_ID) 
    until valid_location?(square)
      square = get_input(player_ID,gameboard)
    end
  if gameboard.ownership?(square,player_ID)
    col = square[0]
    row = square[1]
    return gameboard.squares[row][col]
  else
    puts ""
    puts "That's Not Your Piece! Try Again!"
    puts ""
    square = false
  end
  end
end

def letter_to_col(letter)
  case letter
  when 'a' then return 0
  when 'b' then return 1
  when 'c' then return 2
  when 'd' then return 3
  when 'e' then return 4
  when 'f' then return 5
  when 'g' then return 6
  when 'h' then return 7
  else
    return 99
  end
end

def valid_location?(square)

  if square == false #Stub for first run
    return false 
  end

  col = square[0]
  row = square[1]

  if col.between?(0,7) && row.between?(0,7)
    return true
  else
    puts "" 
    puts "That location isn't even on the board! Try Again!"
    puts "" 
  end
end




=begin
puts "What is Player 1's Name?"
name = gets.chomp
player1 = Player.new(name,1)
puts "What is Player 2's Name?"
name = gets.chomp
player2 = Player.new(name,2)
=end

chessboard = GameBoard.new

#Gameplay Loop

turns = 0
player = 1

until turns == 5  #win?
  chessboard.print_board
  puts ""
  square = verify_input(player,chessboard)
  puts square
  sleep(1)

  if player == 1
    player = 2
  else 
    player = 1
  end

  turns +=1
end