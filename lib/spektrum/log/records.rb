module Spektrum
  module Log

    # Represents a single record from the telemetry file.
    class Record

      attr_reader :timestamp

      def initialize timestamp, raw_data
        if raw_data.length != 15
          raise ArgumentError, "raw_data incorrectly sized (#{raw_data.length})"
        end
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
        @altitude ||= two_byte_field(1..2)
      end

    end

    class BasicDataRecord < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      def rpm pole_count
        raw_rpm * pole_count
      end

      def rpm?
        raw_rpm != 0xFFFF
      end

      def voltage
        raw_voltage / 100.0
      end

      def voltage?
        raw_voltage != 0xFFFF
      end

      def temperature
        @temperature ||= two_byte_field(5..6)
      end

      def temperature?
        self.temperature != 0x7FFF
      end

      private

      def raw_rpm
        @raw_rpm ||= two_byte_field(1..2)
      end

      def raw_voltage
        @raw_voltage ||= two_byte_field(3..4)
      end

    end

    class FlightLogRecord < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      # Gets the receiver pack voltage data.
      #
      # @return [Float] rx voltage data, in volts
      def rx_voltage
        raw_rx_voltage / 100.0
      end

      # Determines if there is receiver voltage data contained within.
      #
      # @return [Boolean] true if there is rx voltage data, false otherwise
      def rx_voltage?
        raw_rx_voltage != 0x7FFF
      end

      private

      def raw_rx_voltage
        @raw_rx_voltage ||= two_byte_field(13..14)
      end

    end

    class GForceRecord < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      def x
        @x ||= two_byte_field(1..2)
      end

      def y
        @y ||= two_byte_field(3..4)
      end

      def z
        @z ||= two_byte_field(5..6)
      end

      def x_max
        @x_max ||= two_byte_field(7..8)
      end

      def y_max
        @y_max ||= two_byte_field(9..10)
      end

      def z_max
        @z_max ||= two_byte_field(11..12)
      end

    end

    class GPSRecord1 < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      def altitude
        @altitude ||= two_byte_field(1..2, :little)
      end

      def latitude_elements
        a = hex_byte_field(6) # degrees
        b = hex_byte_field(5) # degree-minutes
        c = hex_byte_field(4) # degree-minutes / 10
        d = hex_byte_field(3) # degree-minutes / 1000
        [a, b, c, d]
      end

      def latitude
        @latitude ||= mindec_to_degdec latitude_elements
      end

      def longitude_elements
        a = hex_byte_field(10) # degrees
        b = hex_byte_field(9)  # degree-minutes
        c = hex_byte_field(8)  # degree-minutes / 10
        d = hex_byte_field(7)  # degree-minutes / 1000
        [a, b, c, d]
      end

      def longitude
        @longitude ||= mindec_to_degdec longitude_elements
      end

      def coordinate
        [longitude, latitude, altitude]
      end

      def heading
        @heading ||= (two_byte_field(11..12, :little) / 10.0)
      end

      private

      def mindec_to_degdec elts
        raise ArgumentError unless elts.length == 4
        elts[0] + ("#{elts[1]}.#{elts[2]}#{elts[3]}".to_f / 60.0)
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
        @sats ||= byte_field(7)
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
        @speed ||= two_byte_field(1..2)
      end

    end


    class Records

      @@types = {
          0x11 => SpeedRecord,
          0x12 => AltimeterRecord,
          0x14 => GForceRecord,
          0x16 => GPSRecord1,
          0x17 => GPSRecord2,
          0x7E => BasicDataRecord,
          0x7F => FlightLogRecord,
          0xFE => BasicDataRecord,
          0xFF => FlightLogRecord,
      }

      def self.create type, timestamp, raw_data
        @@types.fetch(type, MysteryRecord).new(timestamp, raw_data)
      end

    end

  end
end
