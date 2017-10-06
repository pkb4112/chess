require "game_piece"
require "game_board"
require "player"


describe "GamePiece" do 
  let(:rook) {Rook.new(1)}
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
  end
  context ".path_difference" do 
    it "Returns the difference between the row and column in target square and active square" do
      expect(rook.path_difference([3,0],[0,0])).to eql([3,0])
    end 
  end
  context ".identify_path" do 
    it "Returns an array of each square in the path when given a target square" do
      expect(rook.identify_path([3,0],[0,0])).to eql([[0,0],[1,0],[2,0],[3,0]])
    end 
    it "Returns an array of each square in the path when given a target square" do
      expect(rook.identify_path([0,0],[3,0])).to eql([[3,0],[2,0],[1,0],[0,0]])
    end 
  end
end