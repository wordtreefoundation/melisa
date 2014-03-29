require "melisa/base_config_flags"
require "melisa/search"

module Melisa
  ConfigError = Class.new(StandardError)

  class BaseTrie
    include Enumerable
    
    attr_reader :trie

    # Initialize a BaseTrie.
    # @keys An array of UTF-8 strings
    # @weights Corresponding weights
    # @opts
    #   :binary      Boolean, true for a binary Trie, false for text
    #   :num_tries   An integer from 1 to 127 representing the depth of recursive Tries
    #   :cache_size  One of [:tiny, :small, :normal, :large, :huge]
    #   :order       One of [:label, :weight]
    def initialize(keys=[], weights=[], opts={})
      @trie = Marisa::Trie.new
      build(keys, weights, opts)
    end

    def build(keys=[], weights=[], opts={})
      keyset = Marisa::Keyset.new
      for key, weight in keys.zip(weights)
        push(keyset, key, weight || 1.0)
      end
      @trie.build(keyset, config_flags(opts))
    end

    def search(prefix)
      Search.new(self, prefix)
    end

    def each(&block)
      search('').each(&block)
    end

    def size
      @trie.num_keys()
    end

    def keys
      search('').keys
    end

    def has_keys?
      search('').has_keys?
    end

    def include?(key)
      a = Marisa::Agent.new
      a.set_query(key)
      @trie.lookup(a)
    end

    def read(file_handle)
      self.tap { @trie.read(file_handle.fileno) }
    end

    def write(file_handle)
      self.tap { @trie.write(file_handle.fileno) }
    end

    def load(path)
      self.tap { File.open(path, "r") { |file| read(file) } }
    end

    def save(path)
      self.tap { File.open(path, "w") { |file| write(file) } }
    end

  protected
    include BaseConfigFlags

    def push(keyset, key, weight)
      if weight
        keyset.push_back(key, weight)
      else
        keyset.push_back(key)
      end
      key
    end
  end
end