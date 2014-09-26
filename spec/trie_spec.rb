require_relative "spec_helper"
require 'tempfile'

describe Melisa::Trie do
  let(:terms) { ['one', 'two', 'onetwo'] }
  let(:trie) { Melisa::Trie.new(terms) }

  it "initializes" do
    trie
  end

  it "tests for inclusion" do
    expect(trie).to include 'one'
    expect(trie).to_not include 'three'
  end

  it "lists keys" do
    expect(trie.keys).to match_array ['one', 'two', 'onetwo']
  end

  it "saves" do
    tmp = Tempfile.new('melisa')
    trie.save(tmp.path)

    trie2 = Melisa::Trie.new
    trie2.load(tmp.path)

    expect(trie2.keys).to match_array ['one', 'two', 'onetwo']
  end

  it "gets a key's integer ID" do
    expect(trie.get_id('NOT_KEY1')).to be_nil
    expect(trie.get_id('NOT_KEY2')).to be_nil
    expect(trie.get_id('one')).to eq 0
    expect(trie.get_id('two')).to eq 1
    expect(trie.get_id('onetwo')).to eq 2
  end

  it "gets a key given an ID" do
    expect(trie.get_key(0)).to eq 'one'
    expect(trie.get_key(1)).to eq 'two'
    expect(trie.get_key(2)).to eq 'onetwo'
    expect{ trie.get_key(3) }.to raise_error
  end
end