module Spektrum
  module Log

    class Record

      attr_reader :time

      def initialize time, raw_data
        @time = time
        @raw_data = raw_data
      end

    end

    class AltimeterRecord < Record

      def initialize time, raw_data
        super time, raw_data
      end

    end

    class FlightLogRecord < Record

      def initialize time, raw_data
        super time, raw_data
      end

      def receiver_voltage
        volt = @raw_data[13..14].unpack('n')[0]
        volt / 100.0
      end

    end

    class GForceRecord < Record

      def initialize time, raw_data
        super time, raw_data
      end

    end

    class GPSRecord1 < Record

      def initialize time, raw_data
        super time, raw_data
      end

    end

    class GPSRecord2 < Record

      def initialize time, raw_data
        super time, raw_data
      end

    end

    class MysteryRecord < Record

      def initialize time, raw_data
        super time, raw_data
      end

    end

    class SpeedRecord < Record

      def initialize time, raw_data
        super time, raw_data
      end

    end

    class VoltsTemperatureRPMRecord < Record

      def initialize time, raw_data
        super time, raw_data
      end

      def rpms pole_count
        rpm = @raw_data[1..2].unpack('n')[0]
        rpm * pole_count
      end

      def voltage
        volt = @raw_data[3..4].unpack('n')[0]
        volt / 100.0
      end

      def temperature
        temp = @raw_data[5..6].unpack('n')[0]
        temp
      end

    end

    class Records

      @@types = {
          0x11 => SpeedRecord,
          0x12 => AltimeterRecord,
          0x14 => GForceRecord,
          0x16 => GPSRecord1,
          0x17 => GPSRecord2,
          0x7E => VoltsTemperatureRPMRecord, # TM1000
          0x7F => FlightLogRecord,           # TM1000
          0xFE => VoltsTemperatureRPMRecord, # TM1100
          0xFF => FlightLogRecord,           # TM1100
      }

      def self.create type, time, raw_data
        @@types.fetch(type, MysteryRecord).new(time, raw_data)
      end

    end

  end
end