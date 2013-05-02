module Spektrum
  module Log

    class Record

      attr_reader :time

      def initialize time, raw_data
        @time = time
        @raw_data = raw_data
      end

      protected

      def two_byte_field range
        @raw_data[range].unpack('n')[0]
      end

    end

    class AltimeterRecord < Record

      def initialize time, raw_data
        super time, raw_data
      end

      def altitude
        two_byte_field(1..2)
      end

    end

    class FlightLogRecord < Record

      def initialize time, raw_data
        super time, raw_data
      end

      def receiver_voltage
        volt = two_byte_field(13..14)
        volt / 100.0
      end

    end

    class GForceRecord < Record

      def initialize time, raw_data
        super time, raw_data
      end

      def x
        x = two_byte_field(1..2)
        x
      end

      def y
        y = two_byte_field(3..4)
        y
      end

      def z
        z = two_byte_field(5..6)
        z
      end

      def x_max
        x = two_byte_field(7..8)
        x
      end

      def y_max
        y = two_byte_field(9..10)
        y
      end

      def z_max
        z = two_byte_field(11..12)
        z
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

      def speed
        speed = two_byte_field(1..2)
        speed
      end

    end

    class VoltsTemperatureRPMRecord < Record

      def initialize time, raw_data
        super time, raw_data
      end

      def rpms pole_count
        rpm = two_byte_field(1..2)
        rpm * pole_count
      end

      def voltage
        volt = two_byte_field(3..4)
        volt / 100.0
      end

      def temperature
        temp = two_byte_field(5..6)
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
          0x7E => VoltsTemperatureRPMRecord,
          0x7F => FlightLogRecord,
          0xFE => VoltsTemperatureRPMRecord,
          0xFF => FlightLogRecord,
      }

      def self.create type, time, raw_data
        @@types.fetch(type, MysteryRecord).new(time, raw_data)
      end

    end

  end
end