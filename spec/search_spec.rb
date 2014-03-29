require_relative 'spec_helper'

describe Melisa::Search do 
  let(:keys) { ['one', 'two', 'onetwo'] }
  let(:trie) { Melisa::Trie.new(keys) }
  
  it "iterates with each" do
    arr = []
    trie.each do |key|
      arr << key
    end
    arr.should =~ keys
  end

  it "implements enumerable methods" do
    trie.all? { |k| k.include? 'o' }.should be_true
    trie.any? { |k| k.include? 'z' }.should_not be_true
    trie.map { |k| k.upcase }.should =~ ['ONE', 'TWO', 'ONETWO']
  end

  it "narrows the search" do
    subset = trie.search('one')
    subset.should be_a(Melisa::Search)
    subset.size.should == 2
    subset.keys.should =~ ['one', 'onetwo']
    # subset.map { |k| k.upcase }.should =~ ['ONE', 'ONETWO']
  end

end