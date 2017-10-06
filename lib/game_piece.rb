require_relative "game_board"

class GamePiece
  attr_reader :player_ID, :piece_ID, :moves, :special_moves, :display

  def valid_move?(target_square,active_square,gameboard)
    #if move is in @moves, you can move. Also, overwrite special cases for certain pieces.
  unless is_possible?(target_square,active_square)
    puts "Move not possible!"
    return false
  else
    return true
  end
  end

  def check_target(target_square,gameboard)
    target_piece = gameboard.coord_to_piece(target_square)
    player_ID = self.player_ID

    if target_piece.instance_of? Square
      return "clear"
    elsif target_piece.player_ID == player_ID 
      puts "Your own piece is on that square already"
      return "friendly"
    else
      return "enemy"
    end

  end

  def is_possible?(target_square,active_square)
    dif = path_difference(target_square,active_square)
    self.moves.each_value do |i|
      i.each do |x|
        if dif == x 
          return true
        end
      end
    end
    return false
  end

  def path_difference(target_square,active_square)
    row_dif = (target_square[1] - active_square[1])  # positive up
    col_dif = (target_square[0] - active_square[0]) # positive right
    dif = [col_dif,row_dif]
    return dif
  end

  def identify_path(target_square,active_square)
    dif = path_difference(target_square,active_square)
 
    active_col = active_square[0]
    active_row = active_square[1]
    target_col = target_square[0]
    target_row = target_square[1]

    if dif[0] > 0
      col_path = *(active_col..target_col)
    elsif dif[0] < 0
      col_path = *active_col.downto(target_col)
    else 
      col_path = Array.new(dif[1].abs+1){0}  # No change in column, just add zeroes to zip
    end
    
    if dif[1] > 0
      row_path = *(active_row..target_row)
    elsif dif[1] < 0
      row_path = *active_row.downto(target_row)
    else 
      row_path = Array.new(dif[0].abs+1){0} # No change in row, just add zeroes to zip
    end 

    path = col_path.zip(row_path)

    return path
  end

  def check_path(target_square,active_square,gameboard)
    path = identify_path(target_square,active_square)
    path.shift
    path.pop
    active_piece = self
    player_ID = self.player_ID
    path.map!{|x| gameboard.coord_to_piece(x)} #Convert the coordinates to the corresponding game piece
    path.select!{|x| !(x.instance_of? Square)} #Get rid of the squares
    unless path.empty? # If there's nothing in the way, path is clear. 
      obstacle = path.first
        if x.player_ID == player_ID
          puts "There is a piece from your own team in the way."
          return "friendly"
        else
          puts "There is an enemy piece in the way of your path."
          return "enemy"
        end
    end
   return "clear"
  end


  


  #Type of piece
  #ID number of each piece
  #possible moves
  #which player it belongs to
  #maybe keeps track of its own location?

end # GamePiece class end

class Pawn < GamePiece

  def initialize(player_ID)
    @player_ID = player_ID

    case player_ID
    when 1  #white
      @display = "\u2659"

      @moves = { 
        fwd: [+1,0],
      }

      @special_moves = {

        take_l: [+1,-1],
        take_r: [+1,+1],
        start: [+2,0]
      }
    
    when 2 #black
      @display = "\u265F"

      @moves = { 
        fwd: [-1,0],
      }

      @special_moves = {

        take_l: [-1,-1],
        take_r: [-1,+1],
        start: [-2,0]
      }

    end
  end

end #Pawn end

class Rook < GamePiece
  def initialize(player_ID)
    @player_ID = player_ID

    case player_ID 
    when 1  #white
      @display = "\u2656"
      @moves = {
        up: [[+1,0],[+2,0],[+3,0],[+4,0],[+5,0],[+6,0],[+7,0]],
        down:[[-1,0],[-2,0],[-3,0],[-4,0],[-5,0],[-6,0],[-7,0]],
        left: [[0,-1],[0,-2],[0,-3],[0,-4],[0,-5],[0,-6],[0,-7]],
        right:[[0,+1],[0,+2],[0,+3],[0,+4],[0,+5],[0,+6],[0,+7]]
        
      }

      @special_moves = {

       
      }
      
    when 2 #black
      @display = "\u265C"

      @moves = { 
        up:[[-1,0],[-2,0],[-3,0],[-4,0],[-5,0],[-6,0],[-7,0]],
        down: [[+1,0],[+2,0],[+3,0],[+4,0],[+5,0],[+6,0],[+7,0]],
        left: [[0,-1],[0,-2],[0,-3],[0,-4],[0,-5],[0,-6],[0,-7]],
        right:[[0,+1],[0,+2],[0,+3],[0,+4],[0,+5],[0,+6],[0,+7]]
       
      }

      @special_moves = {

       
      }

    end
  end

end #Rook end

class Bishop <GamePiece
  def initialize(player_ID)
    @player_ID = player_ID

    case player_ID 
    when 1  #white
      @display = "\u2657"
      @moves = { 

        diagonalur: [[+1,+1],[+2,+2],[+3,+3],[+4,+4],[+5,+5],[+6,+6],[+7,+7]],
        diagonalul: [[+1,-1],[+2,-2],[+3,-3],[+4,-4],[+5,-5],[+6,-6],[+7,-7]],
        diagonalll: [[-1,+1],[-2,+2],[-3,+3],[-4,+4],[-5,+5],[-6,+6],[-7,+7]],
        diagonallr: [[-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7]]

        
      }

      @special_moves = {

      }
      
    when 2 #black
      @display = "\u265D"

      @moves = { 

        diagonalur: [[+1,+1],[+2,+2],[+3,+3],[+4,+4],[+5,+5],[+6,+6],[+7,+7]],
        diagonalul: [[+1,-1],[+2,-2],[+3,-3],[+4,-4],[+5,-5],[+6,-6],[+7,-7]],
        diagonalll: [[-1,+1],[-2,+2],[-3,+3],[-4,+4],[-5,+5],[-6,+6],[-7,+7]],
        diagonallr: [[-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7]]
       
      }

      @special_moves = {

        
      }

    end
  end

end#Bishop End

class Knight < GamePiece
  def initialize(player_ID)
    @player_ID = player_ID

    case player_ID 
    when 1  #white
      @display = "\u2658"
      @moves = { 

        jumps: [[+2,+1],[+2,-1],[-2,+1],[-2,-1],[+1,+2],[-1,+2],[+1,-2],[-1,-2]]
        
      }

      @special_moves = {

        
      }
      
    when 2 #black
      @display = "\u265E"

      @moves = { 

        jumps: [[+2,+1],[+2,-1],[-2,+1],[-2,-1],[+1,+2],[-1,+2],[+1,-2],[-1,-2]]
        
      }

      @special_moves = {

        
      }

    end
  end

  def valid_move?(target_square,active_square,gameboard)
    #if move is in @moves, you can move. Also, overwrite special cases for certain pieces.
    unless super
      return false
    end
    target = self.check_target(target_square,gameboard)
    case target
    when "clear" then gameboard.move(target_square,active_square)
    when "friendly" then 
      puts "You can't move onto your own piece!"
      return false
    when "enemy" then gameboard.attack(target_square,active_square)
    end 
    return true
  end

end #Knight end


class Queen < GamePiece
  def initialize(player_ID)
    @player_ID = player_ID

    case player_ID 
    when 1  #white
      @display = "\u2655"
      @moves = { 

        up: [[+1,0],[+2,0],[+3,0],[+4,0],[+5,0],[+6,0],[+7,0]],
        down:[[-1,0],[-2,0],[-3,0],[-4,0],[-5,0],[-6,0],[-7,0]],
        left: [[0,-1],[0,-2],[0,-3],[0,-4],[0,-5],[0,-6],[0,-7]],
        right:[[0,+1],[0,+2],[0,+3],[0,+4],[0,+5],[0,+6],[0,+7]],
        diagonalur: [[+1,+1],[+2,+2],[+3,+3],[+4,+4],[+5,+5],[+6,+6],[+7,+7]],
        diagonalul: [[+1,-1],[+2,-2],[+3,-3],[+4,-4],[+5,-5],[+6,-6],[+7,-7]],
        diagonalll: [[-1,+1],[-2,+2],[-3,+3],[-4,+4],[-5,+5],[-6,+6],[-7,+7]],
        diagonallr: [[-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7]]
        


      }

      @special_moves = {

        
      }
      
    when 2 #black
      @display = "\u265B"

      @moves = { 

        up: [[+1,0],[+2,0],[+3,0],[+4,0],[+5,0],[+6,0],[+7,0]],
        down:[[-1,0],[-2,0],[-3,0],[-4,0],[-5,0],[-6,0],[-7,0]],
        left: [[0,-1],[0,-2],[0,-3],[0,-4],[0,-5],[0,-6],[0,-7]],
        right:[[0,+1],[0,+2],[0,+3],[0,+4],[0,+5],[0,+6],[0,+7]],
        diagonalur: [[+1,+1],[+2,+2],[+3,+3],[+4,+4],[+5,+5],[+6,+6],[+7,+7]],
        diagonalul: [[+1,-1],[+2,-2],[+3,-3],[+4,-4],[+5,-5],[+6,-6],[+7,-7]],
        diagonalll: [[-1,+1],[-2,+2],[-3,+3],[-4,+4],[-5,+5],[-6,+6],[-7,+7]],
        diagonallr: [[-1,-1],[-2,-2],[-3,-3],[-4,-4],[-5,-5],[-6,-6],[-7,-7]]
        
      }

      @special_moves = {

        
      }

    end
  end

end #Queen End

class King < GamePiece
  def initialize(player_ID)
    @player_ID = player_ID

    case player_ID 
    when 1  #white
      @display = "\u2654"
      @moves = { 

        up:[+1,0],
        down: [-1,0],
        left: [0,-1],
        right: [0,+1]

      }

      @special_moves = {

        
      }
      
    when 2 #black
      @display = "\u265A"

      @moves = { 
        
        up:[+1,0],
        down: [-1,0],
        left: [0,-1],
        right: [0,+1]
      }

      @special_moves = {

        
      }

    end
  end

end #King End

class Square < GamePiece

  def initialize
    @display = "\u25A2"
  end

end #Square end



