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

      def temperature unit = :f
        @temperature ||= two_byte_field(5..6)
        case unit
        when :f
          @temperature
        when :c
          (@temperature - 32) * (5.0 / 9.0)
        else
          @temperature
        end
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

      # :feet, :meters
      def altitude unit = :feet
        @altitude ||= (hex_byte_field(2) * 100) + hex_byte_field(1)
        case unit
        when :feet
          @altitude * 0.32808399
        when :meters
          @altitude / 10.0
        else
          @altitude
        end
      end

      def latitude
        elements = 6.downto(3).map { |i| hex_byte_field(i) }
        @latitude ||= convert_latlon(elements)
      end

      def longitude
        elements = 10.downto(7).map { |i| hex_byte_field(i) }
        @longitude ||= convert_latlon(elements)
      end

      def coordinate
        [longitude, latitude, altitude(:meters)]
      end

      def heading
        @heading ||= (hex_byte_field(12) * 10) + (hex_byte_field(11) / 10.0)
      end

      private

      def convert_latlon elts
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
        @speed ||= (hex_byte_field(2) * 100) + hex_byte_field(1)
        case unit
        when :knots
          @speed / 10.0
        when :mph
          @speed * 0.115078
        when :kph
          @speed * 0.1852
        else
          @speed
        end
      end

      def time
        elements = 6.downto(3).map { |i| hex_byte_field(i) }
        @time ||= "%.2i:%.2i:%.2i.%.2i" % elements
      end

      def satellites
        @satellites ||= hex_byte_field(7)
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
