require 'rspec'
require 'spec_helper'
require 'guesser'

describe ComputerGuesser do
  let(:guesser) do
    ComputerGuesser.new("Johnny", ["one", "two", "three", "four"])
   end
   
   describe "#get_guess" do
     it "should return a word if no turns are left" do
       expect(guesser.get_guess([nil, nil, nil], 0)).to have(3).items
     end
     
     it "should return a letter if there are multiple turns available" do
       expect(guesser.get_guess([nil, nil, nil], 1)).to have(1).items
     end
     
     it "should return a word if there is only one possible match" do
       expect(guesser.get_guess([nil, "w", nil], 1)).to eq("two")
     end
   
     it "should return one of the three most frequent letter" do
       guesser.possible_words = ["aoaa", "bbvb", "cccr"]
       choices = ["a", "b", "c"]
       expect(choices).to include guesser.get_guess([nil, nil, nil, nil], 1)
     end
   end
end