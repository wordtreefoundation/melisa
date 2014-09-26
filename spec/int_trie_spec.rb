require_relative 'spec_helper'

describe Melisa::IntTrie do
  let(:hash) { {'one' => 1, 'two' => 2, 'onetwo' => 3} }
  let(:trie) { Melisa::IntTrie.new(hash) }

  it "stores values" do
    trie['one'].should == 1
    trie['two'].should == 2
    trie['onetwo'].should == 3
  end

  it "sets and gets values" do
    trie['five'] = 5
    expect(trie['five']).to eq 5
  end

  it "retreives many values by prefix" do
    trie.get_all('one').should =~ [1, 3]
  end
end