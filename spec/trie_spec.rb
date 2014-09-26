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
end