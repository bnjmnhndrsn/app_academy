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
      duped[[7, 1]].remove
      expect(board[[7, 1]]).not_to be_nil
    end
    
    it "should have changes not affect pieces on old board" do
      duped = board.dup
      duped[[5, 1]].promote
      expect(board[[5, 1]].kinged).to be_false
    end
    
    it "should have promoted pieces still be cloned" do
      board[[5, 1]].promote
      duped = board.dup
      expect(board[[5, 1]].kinged).to be_true
    end
  end
  
end