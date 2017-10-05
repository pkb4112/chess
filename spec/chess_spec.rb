require "game_piece"
require "game_board"
require "player"


describe "GamePiece" do 
	context ".is_possible?" do 
		let(:rook) {Rook.new(1)}
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
end