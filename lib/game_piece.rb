require_relative "game_board"

class GamePiece
  attr_reader :player_ID, :piece_ID, :moves, :special_moves, :display

  def verify_move(target_square,active_piece,active_square)
    #if move is in @moves, you can move. Also, overwrite special cases for certain pieces.
  
  end

def path_difference(target_square,active_square)
  row_dif = target_square[1] - active_square[1]   #positive up
  col_dif = target_square[0] - active_square[0]   # positive right
  dif = [col_dif,row_dif]
  return dif
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
        #down:
        #left:
        #right:
        
      }

      @special_moves = {

       
      }
      
    when 2 #black
      @display = "\u265C"

      @moves = { 
       
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
        
      }

      @special_moves = {

      }
      
    when 2 #black
      @display = "\u265D"

      @moves = { 
       
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
        
      }

      @special_moves = {

        
      }
      
    when 2 #black
      @display = "\u265E"

      @moves = { 
        
      }

      @special_moves = {

        
      }

    end
  end

end #Knight end


class Queen < GamePiece
  def initialize(player_ID)
    @player_ID = player_ID

    case player_ID 
    when 1  #white
      @display = "\u2655"
      @moves = { 
        
      }

      @special_moves = {

        
      }
      
    when 2 #black
      @display = "\u265B"

      @moves = { 
        
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
        
      }

      @special_moves = {

        
      }
      
    when 2 #black
      @display = "\u265A"

      @moves = { 
        
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



