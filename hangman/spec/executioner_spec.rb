require 'rspec'
require 'spec_helper'
require 'executioner'

describe Executioner do
  let(:executioner) do
     Executioner.new("Johnny", ["one", "two", "three", "four"])
   end
  
  it "inherits name from player" do
    expect(executioner.respond_to?(:name)).to be_true
  end
  
  describe "#choose_word" do
    
    it "returns the length of a random word" do
      expect(executioner.choose_word).to eq(executioner.word.length)
    end
    
  end
  
  describe "#evaluate_guess" do
    it "returns an empty hash if no words match" do
      executioner.word = "asdf"
      expect(executioner.evaluate_guess("qwerty")).to eq({})
      expect(executioner.evaluate_guess("v")).to eq({})
    end
    
    it "returns a hash with positions indexed by letter" do
      executioner.word = "aardvark"
      expect(executioner.evaluate_guess("a")).to eq({"a" => [0, 1, 5]})
      
      executioner.word = "foo"
      expect(executioner.evaluate_guess("foo")).to eq({"f" => [0], "o" => [1, 2]})
    end
  end
end