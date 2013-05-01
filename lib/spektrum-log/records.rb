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

      def rpms pole_count
        rpm = @raw_data[1,2].unpack('n')[0]
        rpm * pole_count
      end

      def voltage
        volt = @raw_data[3,4].unpack('n')[0]
        volt / 100.0
      end

      def temperature
        temp = @raw_data[5,6].unpack('n')[0]
        temp
      end

    end

    class Record7F < Record

      def initialize time, raw_data
        super time, raw_data
      end

      def voltage
        volt = @raw_data[13,14].unpack('n')[0]
        volt / 100.0
      end

    end

    class Records

      @@types = {
          0x00 => Record,
          0x16 => Record,
          0x17 => Record,
          0x18 => Record,
          0x7E => Record7E, # TM1000
          0x7F => Record7F, # TM1000
          0xFE => Record7E, # TM1100
          0xFF => Record7F, # TM1100
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