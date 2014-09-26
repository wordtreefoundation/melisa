require "melisa/base_config_flags"
require "melisa/search"

module Melisa
  ImmutableError = Class.new(StandardError)

  class Trie
    include Enumerable

    attr_reader :trie

    # Initialize a BaseTrie.
    # @keys    An array of UTF-8 strings
    # @weights An array of corresponding weights
    # @opts
    #   :binary      Boolean, true for a binary Trie, false for text
    #   :num_tries   An integer from 1 to 127 representing the depth of recursive Tries
    #   :cache_size  One of [:tiny, :small, :normal, :large, :huge]
    #   :order       One of [:label, :weight]
    def initialize(keys=[], weights=[], opts={})
      @trie = Marisa::Trie.new
      @keyset = Marisa::Keyset.new
      @options = opts
      @built = false

      add_many(keys, weights)
    end

    def agent
      @agent ||= Marisa::Agent.new
    end

    def build
      @trie.build(@keyset, config_flags(@options))
    end

    def build_if_necessary
      unless @built
        build
        @built = true
      end
    end

    # Note: weight is not the same thing as a value! use a BytesTrie
    # or IntTrie subclass if you want a key/value dictionary
    def add(key, weight=nil)
      raise ImmutableError, "Can't add #{key}, Trie already built" if @built
      self.tap { push(key, weight) }
    end
    alias :<< :add

    def add_many(keys, weights)
      for key, weight in keys.zip(weights)
        push(key, weight)
      end
    end

    def get_id(key)
      build_if_necessary
      agent.set_query(key)
      trie.lookup(agent)
      agent.key_id if agent.key_str
    end

    def get_key(id)
      build_if_necessary
      agent.set_query(id)
      trie.reverse_lookup(agent)
      agent.key_str
    end

    def search(prefix)
      build_if_necessary
      Search.new(self, prefix)
    end

    def each(&block)
      build_if_necessary
      search('').each(&block)
    end

    def size
      build_if_necessary
      @trie.num_keys()
    end

    def keys
      build_if_necessary
      search('').keys
    end

    def has_keys?
      build_if_necessary
      search('').has_keys?
    end

    def include?(key)
      build_if_necessary
      search('').include?(key)
    end

    def load(path)
      self.tap { @trie.load(path); @built = true }
    end

    def save(path)
      build_if_necessary
      self.tap { @trie.save(path) }
    end

  protected
    include BaseConfigFlags

    def push(key, weight=nil)
      if weight
        @keyset.push_back(key) #, weight) # For now, ignore weight due to marisa C++ binding issue
      else
        @keyset.push_back(key)
      end
    end
  end
end