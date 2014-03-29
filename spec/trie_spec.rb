require_relative "spec_helper"

describe Melisa::Trie do
  let(:trie) { Melisa::Trie.new }

  it "sets and gets weight" do
    trie.add("word", 5)
    trie.add("word2", 2)
    # trie["word"].should == 1
  end

  it "adds" do
    trie.add("word", 1)
    trie.add("words", 2)
  end

  context "prefixes_of" do
    it "finds prefixes" do
      # trie.add()
    end
  end
end