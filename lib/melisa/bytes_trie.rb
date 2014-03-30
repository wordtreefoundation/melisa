module Melisa
  VALUE_SEPARATOR = "\xff"

  class BytesTrie < Trie
    def initialize(hash, separator=VALUE_SEPARATOR, opts={})
      super([], [], opts)

      @sep = separator
      @sep_c = separator.force_encoding('binary').ord

      add_many(hash, [])
    end

    def add_many(hash, weights)
      for key, value in hash
        push(raw_key(key, value))
      end
    end

    def include?(key)
      super(key + @sep)
    end

    def get(key)
      build unless @built
      agent = Marisa::Agent.new
      agent.set_query(key + @sep)
      if @trie.predictive_search(agent)
        agent_key_value(agent)
      end
    end
    alias :[] :get

    # Search for many results with a given prefix
    def get_all(key)
      build unless @built
      agent = Marisa::Agent.new
      agent.set_query(key)
      [].tap do |results|
        while @trie.predictive_search(agent)
          results << agent_key_value(agent)
        end
      end
    end

  protected
    def raw_key(key, value)
      key + @sep + value
    end

    def agent_key_value(agent)
      agent.key_str.split(@sep)[1]
    end
  end
end
