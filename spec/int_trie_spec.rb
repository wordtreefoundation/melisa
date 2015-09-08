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

  it "sets and gets values when binary-encoded value has \\xFF" do
    trie['with_ff'] = 15359
    expect(trie['with_ff']).to eq 15359
  end

  it "retreives many values by prefix" do
    trie.get_all('one').should =~ [1, 3]
  end

  it "#each iterates yielding integer values" do
    expect { |b| trie.each(&b) }.to \
      yield_successive_args(['onetwo', 3], ['one', 1], ['two', 2])
  end

  it "#sum produces the total value of subtree" do
    expect(trie.sum).to eq 6
    expect(trie.sum('one')).to eq(4)
    expect(trie.sum('two')).to eq(2)
  end
end