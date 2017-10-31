require 'yaml'
require_relative "game_piece"
require_relative "player"


class GameBoard
  attr_reader :squares

  def initialize
    @squares = Array.new(8) {Array.new(8){Square.new}} #0-7
    new_game
  end

  #Populates the board with game pieces in their starting locations
  def new_game
    #Pawns 
    8.times do |i|
      @squares[1][i] = Pawn.new(1)
    end
    8.times do |i|
      @squares[6][i] = Pawn.new(2)
    end

    #Rooks 
    @squares[0][0] = Rook.new(1)
    @squares[0][7] = Rook.new(1)
    @squares[7][0] = Rook.new(2)
    @squares[7][7] = Rook.new(2)

    #Knights
    @squares[0][1] = Knight.new(1)
    @squares[0][6] = Knight.new(1)
    @squares[7][1] = Knight.new(2)
    @squares[7][6] = Knight.new(2)

    #Bishops
    @squares[0][2] = Bishop.new(1)
    @squares[0][5] = Bishop.new(1)
    @squares[7][2] = Bishop.new(2)
    @squares[7][5] = Bishop.new(2)

    #Queens 
    @squares[0][3] = Queen.new(1)
    @squares[7][3] = Queen.new(2)

    #Kings
    @squares[0][4] = King.new(1)
    @squares[7][4] = King.new(2)
  end

  def save
    data = @squares
    File.open('store.yml','w') do |f|
      f.write(data.to_yaml)
    end
  end

  def load
    data = YAML.load_file('store.yml')
    @squares = data
  end

  def print_board
    system "clear"
    8.times do |i|
      print "#{7-i} "
      i = 7-i            #Print rows ascending from bottom up
      @squares[i].each do |x|
        print " #{x.display} " 
      end
      puts ""
    end
    puts ""
    print "   a  b  c  d  e  f  g  h"
    puts ""
  end

  def pieces_with_index
    pieces = Hash.new
    @squares.each_with_index do |x,row|
      x.each_with_index do |piece,col|
          #If this piece can possibly move to the opossing king, return true
          pieces[piece]=[row,col]
        end
      end
    return pieces
  end

  def kings_with_index
    pieces = pieces_with_index
    kings = pieces.select{|x| x.instance_of? King}
    return kings
  end

  def pieces_for_player(pieces,player_ID)
    # Returns a hash containing all the pieces just for a certain player
    player_pieces = pieces.select {|i,j| i.player_ID == player_ID} 
    return player_pieces
  end


  def in_check?
    #Check all pieces on the board, and if they can access the opposing king, the king is in check.
    pieces = pieces_with_index
    kings = kings_with_index

    pieces.each_key do |i|
     unless i.instance_of? Square
       return [true,i.player_ID] if i.in_check_pos?(kings.values[0],pieces[i],self) #King 1
       return [true,i.player_ID] if i.in_check_pos?(kings.values[1],pieces[i],self) #King 2
      end
    end
    return [false,0]
  end

=begin
  def checkmate?(player_ID)
    #Can any pieces be moved such that in_check? returns false
    player_pieces = pieces_for_player(pieces_with_index,player_ID)
    kings = kings_with_index

    player_pieces.each_key do |piece|

    end

    return [false,0]
  end
=end


  def ownership?(square,player_ID)
    if square == false #For the first loop
      return false
    end

    row = square[0]
    col = square[1]
   

    if @squares[row][col].instance_of? Square 
      return false
    elsif @squares[row][col].player_ID == player_ID
      return true
    else 
      return false
    end
  end

  def coord_to_piece(square)
    piece = @squares[square[0]][square[1]]
    return piece
  end

  def update_at_coord(new_piece,square)
    @squares[square[0]][square[1]] = new_piece
  end

  def attack(target_square,active_square)
    current_piece = coord_to_piece(active_square)
    old_piece = coord_to_piece(target_square)
    update_at_coord(current_piece,target_square)#Check to make sure this doesn't cause reference issues
    update_at_coord(Square.new,active_square) 
    return expose_to_check?(current_piece,old_piece,target_square,active_square)
  end

  def expose_to_check?(current_piece,old_piece,target_square,active_square)
    if in_check?[0] && in_check?[1]!=current_piece.player_ID
      puts "Cannot expose your king to check - Type 'surrender' for checkmate"
      update_at_coord(old_piece,target_square)
      update_at_coord(current_piece,active_square)
      return false
    end
    return true
  end

  def move (target_square,active_square)
    current_piece = coord_to_piece(active_square)
    old_piece = coord_to_piece(target_square)
    update_at_coord(current_piece,target_square) #Check to make sure this doesn't cause reference issues
    update_at_coord(Square.new,active_square)
    return expose_to_check?(current_piece,old_piece,target_square,active_square)
  end
end #GameBoard end

