module Spektrum
  module Log

    # Represents a single record from the telemetry file.
    class Record

      attr_reader :timestamp

      def initialize timestamp, raw_data
        if raw_data.length != 16
          raise ArgumentError, "raw_data incorrectly sized (#{raw_data.length})"
        end
        @timestamp = timestamp
        @raw_data = raw_data
      end

      def type
        @type ||= byte_field(0)
      end

      # Determines if this record should be considered valid.  Definitions of valid
      # will vary by the type of record.
      #
      # @return [Boolean] true if the record is valid, false otherwise
      def valid?
        true
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
        @altitude ||= two_byte_field(2..3)
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
        @temperature ||= two_byte_field(6..7)
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
        @raw_rpm ||= two_byte_field(2..3)
      end

      def raw_voltage
        @raw_voltage ||= two_byte_field(4..5)
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
        @raw_rx_voltage ||= two_byte_field(14..15)
      end

    end

    class GForceRecord < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      def x
        @x ||= two_byte_field(2..3)
      end

      def y
        @y ||= two_byte_field(4..5)
      end

      def z
        @z ||= two_byte_field(6..7)
      end

      def x_max
        @x_max ||= two_byte_field(8..9)
      end

      def y_max
        @y_max ||= two_byte_field(10..11)
      end

      def z_max
        @z_max ||= two_byte_field(12..13)
      end

    end

    class GPSRecord1 < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      # :feet, :meters
      def altitude unit = :feet
        @altitude ||= (hex_byte_field(3) * 100) + hex_byte_field(2)
        case unit
        when :feet
          @altitude * 0.32808399
        when :meters
          @altitude / 10.0
        else
          @altitude
        end
      end

      # + N, - S
      def latitude
        elements = 7.downto(4).map { |i| hex_byte_field(i) }
        @latitude ||= convert_latlon([0, elements].flatten)
      end

      # + E, - W
      def longitude
        elements = 11.downto(8).map { |i| hex_byte_field(i) }

        # 100+ longitude indicator guesses (X marks proven invalid guess):
        #  X upper nybble of 13th byte
        #  - 2nd bit of 14th byte
        hundreds = ((byte_field(15) & 0x04) == 0x04) ? 1 : 0

        # +/- longitude indicator guesses (X marks proven invalid guess):
        #  - 1st bit of 14th byte (1 - pos, 0 - neg)
        multiplier = ((byte_field(15) & 0x02) == 0x02) ? 1 : -1

        elements = [hundreds, elements].flatten
        @longitude ||= multiplier * convert_latlon(elements)
      end

      def coordinate
        [longitude, latitude, altitude(:meters)]
      end

      def heading
        @heading ||= (hex_byte_field(13) * 10) + (hex_byte_field(12) / 10.0)
      end

      def valid?
        !(latitude == 0.0 && longitude == 0.0 && altitude == 0.0)
      end

      private

      def convert_latlon elts
        raise ArgumentError unless elts.length == 5
        elts[0] * 100 + elts[1] + ("#{elts[2]}.#{elts[3]}#{elts[4]}".to_f / 60.0)
      end

    end

    class GPSRecord2 < Record

      def initialize timestamp, raw_data
        super timestamp, raw_data
      end

      # :knots, :mph, :kph
      def speed unit = :knots
        @speed ||= (hex_byte_field(3) * 100) + hex_byte_field(2)
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
        elements = 7.downto(4).map { |i| hex_byte_field(i) }
        @time ||= "%.2i:%.2i:%.2i.%.2i" % elements
      end

      def satellites
        @satellites ||= hex_byte_field(8)
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
        @speed ||= two_byte_field(2..3)
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
