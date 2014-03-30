require_relative "spec_helper"
require 'tempfile'

describe Melisa::Trie do
  let(:terms) { ['one', 'two', 'onetwo'] }
  let(:trie) { Melisa::Trie.new(terms) }

  it "initializes" do
    trie
  end

  it "tests for inclusion" do
    trie.include?('one').should be_true
    trie.include?('three').should_not be_true
  end

  it "lists keys" do
    trie.keys.should =~ ['one', 'two', 'onetwo']
  end

  it "saves" do
    tmp = Tempfile.new('melisa')
    trie.save(tmp.path)

    trie2 = Melisa::Trie.new
    trie2.load(tmp.path)

    trie2.keys.should =~ ['one', 'two', 'onetwo']
  end
end