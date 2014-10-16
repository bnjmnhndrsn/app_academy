require 'spec_helper'
require 'board'

describe Board do
  let(:board){ Board.make_beginning_board }
  
  describe "#dup" do  
    
    it "should return a different board object" do
      expect(board.dup.object_id).not_to eq(board.object_id)
    end
    
    it "should not change if dup is changed" do
      duped = board.dup
      duped[[7, 0]].remove
      expect(board[[7, 0]]).not_to be_nil
    end
    
    it "should have changes not affect pieces on old board" do
      duped = board.dup
      duped[[5, 0]].promote
      expect(board[[5, 0]].kinged).to be_false
    end
  end
  
end