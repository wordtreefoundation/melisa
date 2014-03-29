module Melisa
  class Search
    include Enumerable
    
    def initialize(trie, prefix)
      @trie = trie
      @prefix = prefix
    end

    def search(prefix)
      Search.new(@trie, @prefix + prefix)
    end

    def reset_agent
      # Reset the agent state so predictive_search iterates through all keys
      @agent = Marisa::Agent.new
      @agent.set_query(@prefix)
    end

    def each(&block)
      reset_agent
      # Yield each key
      yield @agent.key_str while @trie.trie.predictive_search(@agent)
    end

    def size
      keys.size
    end

    def keys
      @keys ||= [].tap do |arr|
        reset_agent
        arr << @agent.key_str while @trie.trie.predictive_search(@agent)
      end
    end

    def has_keys?
      reset_agent
      return @trie.trie.predictive_search(@agent)
    end

    def with_prefixes(&block)
      reset_agent
      while @trie.trie.common_prefix_search(@agent)
        block.call(@agent.key_str)
      end
    end
  end
end