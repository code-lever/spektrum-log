module Spektrum
  module Log

    class Record

      attr_reader :timestamp

      def initialize timestamp, raw_data
        @timestamp = timestamp
        @raw_data = raw_data
      end

      protected

      def byte_field range
        @raw_data[range].unpack('C')[0]
      end

      def hex_byte_field range
        @raw_data[range].unpack('H*')[0].to_i
      end

      def two_byte_field range, endian = :big
        @raw_data[range].unpack(endian == :big ? 'n' : 'v')[0]
      end

      def four_byte_field range, endian = :big
        @raw_data[range].unpack(endian == :big ? 'N' : 'V')[0]
      end

    end

    class AltimeterRecord < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      def altitude
        two_byte_field(1..2)
      end

    end

    class FlightLogRecord < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      def receiver_voltage
        volt = two_byte_field(13..14)
        volt / 100.0
      end

    end

    class GForceRecord < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
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

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      def altitude
        alt = two_byte_field(1..2, :little)
        alt
      end

      def latitude
        a = byte_field(3) # 1/100 degree-second
        b = byte_field(4) # degree-seconds
        c = byte_field(5) # degree-minutes
        d = byte_field(6) # degrees
        [d, c, b, a]
      end

      def longitude
        a = byte_field(7) # 1/100 degree-second
        b = byte_field(8) # degree-seconds
        c = byte_field(9) # degree-minutes
        d = byte_field(10) # degrees
        [d, c, b, a]
      end

      def heading
        head = two_byte_field(11..12, :little)
        head / 10.0
      end

    end

    class GPSRecord2 < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      # :knots, :mph, :kph
      def speed unit = :knots
        speed = two_byte_field(1..2, :little)
        speed = case unit
        when :knots
          speed / 10.0
        when :mph
          speed * 0.115
        when :kph
          speed * 0.185
        end
        speed.round(2)
      end

      def time
        ax = hex_byte_field(3) # hundredths
        bx = hex_byte_field(4) # seconds
        cx = hex_byte_field(5) # minutes
        dx = hex_byte_field(6) # hours

        [dx, cx, bx + (ax / 100.0)] # hh:mm:ss.sss
      end

      def sats
        sats = byte_field(7)
        sats
      end

    end

    class MysteryRecord < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

    end

    class SpeedRecord < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      def speed
        speed = two_byte_field(1..2)
        speed
      end

    end

    class VoltsTemperatureRPMRecord < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
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

      def self.create type, timestamp, raw_data
        @@types.fetch(type, MysteryRecord).new(timestamp, raw_data)
      end

    end

  end
end