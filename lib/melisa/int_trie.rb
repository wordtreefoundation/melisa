module Melisa
  class IntTrie < BytesTrie
  protected
    def raw_key(key, value)
      key + @sep + [value.to_i].pack('i*')
    end

    def agent_key_value(agent)
      if value = agent.key_str.split(@sep)[1]
        value.unpack('i*').first
      end
    end
  end
end