module Melisa
  VALUE_SEPARATOR = "\xff"

  class BytesTrie < Trie
    def initialize(hash={}, separator=VALUE_SEPARATOR, opts={})
      super([], [], opts)

      @sep = separator
      @sep_c = separator.force_encoding('binary').ord

      add_many(hash, [])
    end

    def add_many(hash, weight=nil)
      for key, value in hash
        push(key_and_value_as_string(key, value), weight)
      end
    end

    def include?(key)
      super(key + @sep)
    end

    def get(key)
      build_if_necessary
      agent.set_query(key + @sep)
      if @trie.predictive_search(agent)
        agent_key_value(agent)
      end
    end
    alias :[] :get

    def set(key, value)
      add(key_and_value_as_string(key, value))
    end
    alias :[]= :set

    # Search for many results with a given prefix
    def get_all(key)
      build_if_necessary
      agent.set_query(key)
      [].tap do |results|
        while @trie.predictive_search(agent)
          results << agent_key_value(agent)
        end
      end
    end

    def each(&block)
      search('').each do |str|
        yield string_as_key_and_value(str)
      end
    end

  protected

    # Can be overridden by subclasses
    def serialize_value(value)
      value
    end

    # Can be overridden by subclasses
    def unserialize_value(value)
      value
    end

    def key_and_value_as_string(key, value)
      key + @sep + serialize_value(value)
    end

    def string_as_key_and_value(str)
      key, binary_value = str.split(@sep)
      [key, unserialize_value(binary_value)]
    end

    def agent_key_value(agent)
      unserialize_value(agent.key_str.split(@sep).last)
    end
  end
end
