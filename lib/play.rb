require_relative "player"
require_relative "game_board"
require_relative "game_piece"


def get_input(player_ID,gameboard)
  while true 
    begin
      input = gets.chomp
      if input == "save"
        gameboard.save
        exit
      elsif input == "load"
        gameboard.load
        puts "Loaded"
        gameboard.print_board
        puts "Player #{player_ID}: Please input the location of the piece you would like to move (ex. 'a3')"
        input = gets.chomp
      elsif input == "retry"
        return false
      end
        letter = input.match(/(^[a-zA-Z])/)[0].downcase
        col = letter_to_col(letter)
        row = input.match(/(\d$)/)[0].to_i
        square = [row,col] #changed from col,row to row,col may break stuff
        return square
    rescue
     puts "Invalid Input!"
     puts ""
     sleep(1)
     system "clear"
     gameboard.print_board
    end
  end
end

def select_a_piece(player_ID,gameboard)
    puts "Player #{player_ID}: Please input the location of the piece you would like to move (ex. 'a3'), or enter 'Save' to save and exit"
    return get_input(player_ID,gameboard)
end

def get_target(player_ID,gameboard)
    puts "Player #{player_ID}: Please input the location you would like to move to (ex. 'a3')"
    return get_input(player_ID,gameboard)
end

def verify_input(player_ID,gameboard)
  square = false
  until gameboard.ownership?(square,player_ID) 
    until valid_location?(square)
      square = select_a_piece(player_ID,gameboard)
    end
  if gameboard.ownership?(square,player_ID)
    return square
  else
    puts ""
    puts "That's Not Your Piece! Try Again!"
    puts ""
    square = false
  end
  end
end

def verify_target(active_square,gameboard,player_ID)
  piece = gameboard.coord_to_piece(active_square)
  target_square = get_target(player_ID,gameboard)
  
  until (valid_location?(target_square) && piece.valid_move?(target_square,active_square,gameboard)) || target_square == false
   puts""
   puts "Try Again!"
   puts "or type 'retry' to select another piece"
   puts ""
   target_square = get_target(player_ID,gameboard)
  end
  if target_square == false
    return false
  else
   return true
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

  row = square[0]
  col = square[1]
  

  if col.between?(0,7) && row.between?(0,7)
    return true
  else
    puts "" 
    puts "That location isn't even on the board!"
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

until turns == 10  #win?
  chessboard.print_board
  puts ""
  puts "Check!" if chessboard.in_check?[0]
  puts ""
  active_square = verify_input(player,chessboard) 
  until verify_target(active_square,chessboard,player)
    puts "insdie"
    active_square = verify_input(player,chessboard) 
  end
  puts "yay!"
  

  
  sleep(1)

  if player == 1
    player = 2
  else 
    player = 1
  end

  turns +=1
end