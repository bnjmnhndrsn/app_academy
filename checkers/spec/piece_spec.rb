require 'spec_helper'
require 'piece'
require 'game'

describe Piece do
  let(:pos1) { [4, 4] }
  let(:pos2) { [5, 5] }
  let(:pos3) { [3, 5] }
  let(:pos4) { [1, 5] }
  let(:b) do 
    b = Board.new 
    b[pos1] = Piece.new(:black, pos1, b)
    b[pos2] = Piece.new(:black, pos2, b)
    b[pos3] = Piece.new(:white, pos3, b)
    b[pos4] = Piece.new(:white, pos4, b)
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
    it "should return true if jump is valid (black)" do
      expect(b[pos3].perform_jump([5, 3])).to be_true
    end
    
    it "should return true if jump is valid (white)" do
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
    
    it "should move piece to new space" do
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
      king = Piece.new(:white, [6, 4], b)
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
      piece = Piece.new(:black, [1, 1], b)
      piece.perform_slide([0, 0])
      expect(piece.kinged).to be_true
      expect(piece.perform_slide([1, 1])).to be_true
    end
    
    it "should promote white pieces correctly" do
      piece = Piece.new(:white, [6, 1], b)
      piece.perform_slide([7, 0])
      expect(piece.kinged).to be_true
      expect(piece.perform_slide([6, 1])).to be_true
    end
    
  end
  
  describe "perform moves!" do
    it "should be able to perform one slide" do
      piece = b[pos1]
      b[pos1].perform_moves!([[3, 3]])
      expect(b[pos1]).to be_nil
      expect(b[[3, 3]]).to eq(piece)
    end
    
    it "should be able to perform one jump" do
      piece = b[pos1]
      b[pos1].perform_moves!([[2, 6]])
      expect(b[pos1]).to be_nil
      expect(b[[2, 6]]).to eq(piece)
    end
    
    it "should be able to perform multiple jumps" do
      piece = b[pos1]
      b[pos1].perform_moves!([[2, 6], [0, 4]])
      expect(b[pos1]).to be_nil
      expect(b[[2, 6]]).to be_nil
      expect(b[[0, 4]]).to eq(piece)
      expect(b[pos3]).to be_nil
      expect(b[pos4]).to be_nil
    end
    
    it "should raise error if 1 slide sequence is invalid" do
      expect {b[pos1].perform_moves!([[5, 3]]) }.to raise_error(InvalidMoveError)
    end
    
    it "should raise error if 1 jump sequence is invalid" do
      expect {b[pos1].perform_moves!([[2, 2]]) }.to raise_error(InvalidMoveError)
    end
    
    it "should raise error if multi-jump sequence is invalid" do
      expect {b[pos1].perform_moves!([[2, 6], [4, 4]]) }.to raise_error(InvalidMoveError)
    end
    
  end
  
  describe "valid_move_seq?" do
    
    it "should return true for one valid slide" do
      expect( b[pos1].valid_move_seq?([[3, 3]]) ).to be_true
    end
    
    it "should be able to perform one jump" do
     expect( b[pos1].valid_move_seq?([[2, 6]]) ).to be_true
    end
    
    it "should be able to perform multiple jumps" do
     expect( b[pos1].valid_move_seq?([[2, 6], [0, 4]]) ).to be_true

    end
    
    it "should raise error if 1 slide sequence is invalid" do
      expect( b[pos1].valid_move_seq?([[5, 3]]) ).to be_false
    end
    
    it "should raise error if 1 jump sequence is invalid" do
      expect( b[pos1].valid_move_seq?([[2, 2]]) ).to be_false
    end
    
    it "should raise error if multi-jump sequence is invalid" do
      expect( b[pos1].valid_move_seq?([[2, 6], [4, 4]]) ).to be_false
    end
  
  end
  
  describe "perform moves" do
    it "should be able to perform one slide" do
      piece = b[pos1]
      b[pos1].perform_moves([[3, 3]])
      expect(b[pos1]).to be_nil
      expect(b[[3, 3]]).to eq(piece)
    end
    
    it "should be able to perform one jump" do
      piece = b[pos1]
      b[pos1].perform_moves([[2, 6]])
      expect(b[pos1]).to be_nil
      expect(b[[2, 6]]).to eq(piece)
    end
    
    it "should be able to perform multiple jumps" do
      piece = b[pos1]
      b[pos1].perform_moves([[2, 6], [0, 4]])
      expect(b[pos1]).to be_nil
      expect(b[[2, 6]]).to be_nil
      expect(b[[0, 4]]).to eq(piece)
      expect(b[pos3]).to be_nil
      expect(b[pos4]).to be_nil
    end
    
    it "should raise error if 1 slide sequence is invalid" do
      expect {b[pos1].perform_moves([[5, 3]]) }.to raise_error(InvalidMoveError)
    end
    
    it "should raise error if 1 jump sequence is invalid" do
      expect {b[pos1].perform_moves([[2, 2]]) }.to raise_error(InvalidMoveError)
    end
    
    it "should raise error if multi-jump sequence is invalid" do
      expect {b[pos1].perform_moves([[2, 6], [4, 4]]) }.to raise_error(InvalidMoveError)
    end
  end

  
end