require 'spec_helper'
require 'piece'
require 'game'

describe Piece do
  let(:pos1) { [4, 4] }
  let(:pos2) { [5, 5] }
  let(:pos3) { [3, 5] }
  let(:b) do 
    b = Board.new 
    b[pos1] = Piece.new(:white, pos1, b)
    b[pos2] = Piece.new(:white, pos2, b)
    b[pos3] = Piece.new(:black, pos3, b)
    b
  end
  
  describe "#perform_slide" do
    it "should return true if slide is valid (white)" do
      expect(b[pos1].perform_slide([3, 3])).to be_true
      expect(b[pos2].perform_slide([4, 6])).to be_true
    end
    
    it "should return true if slide is valid (black)" do
        expect(b[pos3].perform_slide([4, 6])).to be_true
    end
    
    it "should return false if sliding into enemy pieces" do
      expect(b[pos2].perform_slide(pos1)).to be_false
    end
    
    it "should return false if slide into own pieces" do  
      expect(b[pos3].perform_slide(pos1)).to be_false
    end
    
    it "should return false if sliding backwards" do
      expect(b[pos1].perform_slide([5, 3])).to be_false
    end
    
    it "should return false if sliding multiple spaces" do
      expect(b[pos1].perform_slide([2, 2])).to be_false
    end
    
    it "should remove piece from current space" do
      b[pos1].perform_slide([3, 3])
      expect(b[pos1]).to be_nil
    end
    
    it "should move piece into new space" do
      piece = b[pos1]
      b[pos1].perform_slide([3, 3])
      expect(b[[3, 3]]).to eq(piece)
    end
  end
  
  describe "#perform_jump" do
    it "should return true if jump is valid (white)" do
      expect(b[pos3].perform_jump([5, 3])).to be_true
    end
    
    it "should return true if jump is valid (black)" do
      expect(b[pos1].perform_jump([2, 6])).to be_true
    end
    
    it "should return false if jump is one space" do
      expect(b[pos1].perform_jump([3, 3])).to be_false
    end
        
    it "should return false if jump is over teammate" do
      expect(b[pos3].perform_jump([3, 3])).to be_false
    end
    
    it "should return false if jumping over no piece" do
      expect(b[pos1].perform_jump([2, 2])).to be_false
    end
       
    it "should return false if jumping backwards" do
      expect(b[pos1].perform_jump([6, 2])).to be_false
    end
    
    it "should remove move piece from old space" do
      b[pos3].perform_jump([5, 3])
      expect(b[pos3]).to be_nil
    end
    
    it "should remove move piece to new space" do
      piece = b[pos3]
      b[pos3].perform_jump([5, 3])
      expect(b[[5, 3]]).to eq(piece)
    end
    
    it "should remove piece jumped over" do
      b[pos3].perform_jump([5, 3])
      expect(b[pos1]).to be_nil
    end
  end
  
  describe "kinged piece" do
    let(:king) do
      king = Piece.new(:black, [6, 4], b)
      king.promote
      king
    end
    before(:each) { b[[6, 4]] = king }
    
    it "should be able to slide forwards" do
      expect(king.perform_slide([5, 3])).to be_true
    end
    
    it "should be able to slide backwards" do
      expect(king.perform_slide([7, 3])).to be_true
    end
    
    it "should be able to jump backwards" do
      expect(king.perform_jump([4, 6])).to be_true
    end
  end
  
  describe "promotion" do
    
    it "should promote black pieces correctly" do
      piece = Piece.new(:black, [6, 1], b)
      piece.perform_slide([7, 0])
      expect(piece.kinged).to be_true
    end
    
    it "should promote white pieces correctly" do
      piece = Piece.new(:white, [1, 1], b)
      piece.perform_slide([0, 0])
      expect(piece.kinged).to be_true
    end

     
  end
  
end