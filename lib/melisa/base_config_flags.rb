module Melisa
  ConfigError = Class.new(StandardError)

  CacheSizes = {
    :huge    => Marisa::HUGE_CACHE,
    :large   => Marisa::LARGE_CACHE,
    :normal  => Marisa::NORMAL_CACHE,
    :small   => Marisa::SMALL_CACHE,
    :tiny    => Marisa::TINY_CACHE,
    :default => Marisa::NORMAL_CACHE
  }

  NodeOrders = {
    :label   => Marisa::LABEL_ORDER,
    :weight  => Marisa::WEIGHT_ORDER,
    :default => Marisa::DEFAULT_ORDER
  }

  module BaseConfigFlags
    def config_flags(opts={})
      opts = {
        :binary     => false,
        :num_tries  => :default,
        :cache_size => :default,
        :order      => :default
      }.merge(opts)

      return \
        binary_flag(opts[:binary]) |
        valid_num_tries(opts[:num_tries]) |
        lookup_cache_size(opts[:cache_size]) |
        valid_node_order(opts[:order])
    end

    def binary_flag(bool)
      case bool
      when true  then Marisa::BINARY_TAIL
      when false then Marisa::TEXT_TAIL
      else
        raise ArgumentError, "binary_flag must be true or false (got #{bool.inspect})"
      end
    end

    def valid_num_tries(num_tries)
      num_tries = Marisa::DEFAULT_NUM_TRIES if num_tries == :default
      min = Marisa::MIN_NUM_TRIES
      max = Marisa::MAX_NUM_TRIES
      if (min..max).include? num_tries
        return num_tries
      else
        msg = "num_tries (#{num_tries}) must be between #{min} and #{max}"
        raise ConfigError, msg
      end
    end

    def lookup_cache_size(cache_size)
      if CacheSizes.keys.include?(cache_size)
        return CacheSizes[cache_size]
      else
        sizes = CacheSizes.keys
        msg = "cache_size (#{cache_size}) must be one of: #{sizes.inspect}"
        raise ConfigError, msg
      end
    end

    def valid_node_order(order)
      if NodeOrders.keys.include?(order)
        return NodeOrders[order]
      else
        valid_options = NodeOrders.keys
        msg = "node_order (#{order}) must be one of: #{valid_options.inspect}"
        raise ConfigError, msg
      end
    end
  end
end