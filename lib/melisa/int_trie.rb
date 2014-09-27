module Melisa
  class IntTrie < BytesTrie
    def sum(prefix='')
      search(prefix).each.inject(0) do |total,str|
        total + unserialize_value(str.split(@sep).last)
      end
    end

  protected
    # Serialize as big-endian (network ordered) Integer value
    def serialize_value(value)
      [value.to_i].pack('N')
    end

    def unserialize_value(value)
      value.unpack('N').first
    end
  end
end