require_relative "game_board"

class GamePiece
  attr_reader :player_ID, :piece_ID, :moves, :special_moves, :starting_moves, :display

  def valid_move?(target_square,active_square,gameboard)
    #if move is in @moves, you can move. Also, overwrite special cases for certain pieces.
    if  !(is_possible?(target_square,active_square,gameboard))
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
      return "friendly"
    else
      return "enemy"
    end
  end

  def is_possible?(target_square,active_square,gameboard)
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
    row_dif = (target_square[0] - active_square[0])  # positive up
    col_dif = (target_square[1] - active_square[1]) # positive right
    dif = [row_dif,col_dif]
    return dif
  end

  def identify_path(target_square,active_square)
    dif = path_difference(target_square,active_square)
 
    active_row = active_square[0]
    active_col = active_square[1]
    target_row = target_square[0]
    target_col = target_square[1]
    

    if dif[1] > 0 #Column difference
      col_path = *(active_col..target_col) #Array of active column to target column
    elsif dif[1] < 0
      col_path = *active_col.downto(target_col)
    else 
      col_path = Array.new(dif[0].abs+1){active_col}  # No change in column, just add current col to zip
    end
    
    if dif[0] > 0 #Row difference
      row_path = *(active_row..target_row)
    elsif dif[0] < 0
      row_path = *active_row.downto(target_row)
    else 
      row_path = Array.new(dif[1].abs+1){active_row} # No change in row, just add current row  to zip
    end 

    path = row_path.zip(col_path)
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
        if obstacle.player_ID == player_ID 
          return "friendly"
        else
          return "enemy"
        end
    end
   return "clear"
  end

  def target_move(target_square,active_square,gameboard)
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
  
  def path_move(target_square,active_square,gameboard)
    path = check_path(target_square,active_square,gameboard)
    case path
    when "clear" 
      return true
    when "friendly"
      puts "There is a piece from your own team in the way."
      return false
    when "enemy" 
      puts "There is an enemy piece in the way of your path."
      return false
    end 
    return true
  end

  def in_check_pos?(target_square,active_square,gameboard)
    return false unless is_possible?(target_square,active_square,gameboard)
    if check_target(target_square,gameboard) == "enemy"
      return true
    else
    return false
    end
  end

end # GamePiece class end

class Pawn < GamePiece
  attr_accessor :starting_pos

  def initialize(player_ID)
    @player_ID = player_ID
    @starting_pos = true

    case player_ID
    when 1  #white
      @display = "\u2659"

      @moves = { 
        fwd: [+1,0],
      }

      @special_moves = {

        take_l: [+1,-1],
        take_r: [+1,+1],
        
      }

      @starting_moves = {
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
        
      }

      @starting_moves = {
        start: [-2,0]
      }

    end
  end

  def is_possible?(target_square,active_square,gameboard)
    dif = path_difference(target_square,active_square)
    if @starting_pos == true
      self.starting_moves.each_value do |i|
        if dif == i 
          @starting_pos = false
          return true
        end 
      end
    end
    self.moves.each_value do |i|
        if dif == i
           @starting_pos = false
          return true
        end
    end
    if check_target(target_square,gameboard) == "enemy"
      self.special_moves.each_value do |i|
        if dif == i 
           @starting_pos = false
          return true
        end
      end
    end
    return false
  end

  def valid_move?(target_square,active_square,gameboard)
    #if move is in @moves, you can move. Also, overwrite special cases for certain pieces.
    unless is_possible?(target_square,active_square,gameboard)
      return false
    end
   target_move(target_square,active_square,gameboard)

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

  def valid_move?(target_square,active_square,gameboard)
    #if move is in @moves, you can move. Also, overwrite special cases for certain pieces.
    unless super
      return false
    end
    unless path_move(target_square,active_square,gameboard)
      return false
    end
    return target_move(target_square,active_square,gameboard)
  end

  def in_check_pos?(target_square,active_square,gameboard) 
    if super && check_path(target_square,active_square,gameboard) == "clear" 
      return true
    else
      return false
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

  def valid_move?(target_square,active_square,gameboard)
    #if move is in @moves, you can move. Also, overwrite special cases for certain pieces.
    unless super
      return false
    end
    unless path_move(target_square,active_square,gameboard)
      return false
    end
    return target_move(target_square,active_square,gameboard)
  end

  def in_check_pos?(target_square,active_square,gameboard) 
    if super && check_path(target_square,active_square,gameboard) == "clear" 
      return true
    else
      return false
    end
  end

end #Bishop End

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
   return target_move(target_square,active_square,gameboard)
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

  def valid_move?(target_square,active_square,gameboard)
    unless super
      return false
    end
    unless path_move(target_square,active_square,gameboard)
      return false
    end
    return target_move(target_square,active_square,gameboard)
  end

  def in_check_pos?(target_square,active_square,gameboard) 
    if super && check_path(target_square,active_square,gameboard) == "clear" 
      return true
    else
      return false
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

        up: [[+1,0]],
        down: [[-1,0]],
        left: [[0,-1]],
        right: [[0,+1]]

      }

      @special_moves = {

        
      }
      
    when 2 #black
      @display = "\u265A"

      @moves = { 
        
        up: [[+1,0]],
        down: [[-1,0]],
        left: [[0,-1]],
        right: [[0,+1]]
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
   return target_move(target_square,active_square,gameboard)
  end

end #King End

class Square < GamePiece

  def initialize
    @display = "\u25A2"
  end

end #Square end



