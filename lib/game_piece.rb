class GamePiece
  attr_reader :player_ID, :piece_ID, :moves, :special_moves, :display

  def verify_move()
    #if move is in @moves, you can move. Also, over write special cases for certain pieces. 
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



