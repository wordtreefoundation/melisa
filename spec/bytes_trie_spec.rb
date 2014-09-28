require_relative 'spec_helper'

describe Melisa::BytesTrie do
  let(:hash) { {'one' => '1', 'two' => '2', 'onetwo' => '3'} }
  let(:trie) { Melisa::BytesTrie.new(hash) }

  it "stores values" do
    expect(trie['one']).to eq '1'
    expect(trie['two']).to eq '2'
    expect(trie['onetwo']).to eq '3'
  end

  it "sets and gets values" do
    trie['five'] = "5"
    expect(trie['five']).to eq "5"
  end

  it "retreives many values by prefix" do
    expect(trie.get_all('one')).to match_array ['1', '3']
  end

  it "#each iterates alphabetically and yields key/value pairs" do
    expect { |b| trie.each(&b) }.to \
      yield_successive_args(['onetwo', '3'], ['one', '1'], ['two', '2'])
  end
end