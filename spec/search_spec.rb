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
    expect(trie.all? { |k| k.include? 'o' }).to be_truthy
    expect(trie.any? { |k| k.include? 'z' }).to be_falsy
    expect(trie.map { |k| k.upcase }).to match_array ['ONE', 'TWO', 'ONETWO']
  end

  it "narrows the search" do
    subset = trie.search('one')
    expect(subset).to be_a(Melisa::Search)
    expect(subset.size).to eq 2
    expect(subset.keys).to match_array ['one', 'onetwo']
  end

end