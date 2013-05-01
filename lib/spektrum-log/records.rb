module Spektrum
  module Log

    class Record

      attr_reader :time

      def initialize time, raw_data
        @time = time
        @raw_data = raw_data
      end

    end

    class Record7E < Record

      def initialize time, raw_data
        super time, raw_data
      end

    end

    class Record7F < Record

      def initialize time, raw_data
        super time, raw_data
      end

    end

    class Records

      @@types = {
          0x00 => Record,
          0x16 => Record,
          0x17 => Record,
          0x18 => Record,
          0x7E => Record7E,
          0x7F => Record7F,
          0xFE => Record,
          0xFF => Record,
      }

      def self.create type, time, raw_data
        if @@types.has_key? type
          @@types[type].new(time, raw_data)
        else
          puts type
        end
      end

    end

  end
end