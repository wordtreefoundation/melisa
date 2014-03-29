module Melisa
  class Trie
    attr_reader :trie, :keyset

    def initialize
      @trie = Marisa::Trie.new
      @keyset = Marisa::Keyset.new
      @agent = Marisa::Agent.new

      @built = false
    end

    def add(term, weight=nil)
      raise_if_built("add")
      if weight
        @keyset.push_back(term, weight)
      else
        @keyset.push_back(term)
      end
      term
    end

    def size
      @keyset.size
    end

    def [](key)
      build_if_necessary
      @agent.set_query(key)
      if @trie.lookup(@agent)
        # require 'debugger'; debugger
        return @agent.key.weight
      else
        return false
      end
    end

    def prefixes_of(search_term, &block)
      build_if_necessary

      @agent.set_query(search_term)

      while @trie.common_prefix_search(@agent)
        key = @agent.key
        block.call(key.str, key.weight)
      end
    end

  protected

    def built?
      @built
    end

    def raise_if_built(verb="do that")
      return unless built?
      raise ImmutableError, "can't #{verb}, Trie is already built and therefore immutable"
    end

    def build_if_necessary
      @trie.build(@keyset) if not built?
    end
  end
end