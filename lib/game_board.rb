require_relative "game_piece"
require_relative "player"


class GameBoard
  attr_accessor :squares

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

end #GameBoard end

class Square
  attr_accessor :display

  def initialize(display = "\u25A2")
    @display = display
  end

end