require "game_piece"
require "game_board"
require "player"


describe "GamePiece" do 
  let(:rook) {Rook.new(1)}
  let(:knight) {Knight.new(1)}
  let(:chessboard){GameBoard.new}
  describe "#is_possible?" do
    context ".is_possible?" do 
      it "Returns true if the propsed move is included in piece possible moves" do
        expect(rook.is_possible?([5,0],[0,0])).to eql(true)
        end
        it "Returns false if the propsed move is not included in piece possible moves" do
        expect(rook.is_possible?([5,3],[0,0])).to eql(false)
        end
        it "Returns false if the proposed move is the same spot as the active square" do
          expect(rook.is_possible?([0,0],[0,0])).to eql(false)
        end
        it "Returns false if the propsed move is not included in piece possible moves" do
          expect(knight.is_possible?([2,1],[0,1])).to eql(false)
        end
        it "Returns true if the propsed move is included in piece possible moves" do
          expect(knight.is_possible?([2,0],[0,1])).to eql(true)
        end
    end
  end
  describe "#path_difference" do
    context ".path_difference" do 
      it "Returns the difference between the row and column in target square and active square" do
        expect(rook.path_difference([3,0],[0,0])).to eql([3,0])
      end 
    end
  end
  describe "#identify_path" do
    context ".identify_path" do 
      it "Returns an array of each square in the path when given a target square" do
        expect(rook.identify_path([3,0],[0,0])).to eql([[0,0],[1,0],[2,0],[3,0]])
      end 
      it "Returns an array of each square in the path when given a target square" do
        expect(rook.identify_path([0,0],[3,0])).to eql([[3,0],[2,0],[1,0],[0,0]])
      end 
    end
  end
  describe ".check_target" do
    context "Checks a square and returns if the target is 'clear', 'friendly', or 'enemy'" do
      it "Returns clear if the space is clear" do
        expect(knight.check_target([2,0],chessboard)).to eql("clear")
      end
    end
  end

  describe ".valid_move?" do 
    context "returns true or false depending on whether a move can be made. Makes the move if it can" do
      it "returns true if Knight at [0,1] moves to [2,0]" do
        expect(knight.valid_move?([2,0],[0,1],chessboard)).to eql(true)
    end 
  end
end


end

describe "GameBoard" do 
  let(:chessboard){GameBoard.new}
  describe "#coord_to_piece" do
    context "Given a [row,col] coordinate it returns the gamepiece in that spot" do
      it "Returns a Rook instance if given [0,0]" do 
        expect(chessboard.coord_to_piece([0,0])).to be_instance_of(Rook)
      end
      it "Returns a Knight instance if given [0,1]" do 
        expect(chessboard.coord_to_piece([0,1])).to be_instance_of(Knight)
      end
      it "Returns a Knight instance if given [0,1]" do 
        expect(chessboard.coord_to_piece([7,1])).to be_instance_of(Knight)
      end
    end
  end
end