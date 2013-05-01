module Spektrum
  module Log

    class Flight

      attr_reader :headers, :records

      def initialize(headers, records)
        @headers = headers
        @records = records
      end

      def duration
        @records.empty? ? 0 : @records.last.time - @records.first.time
      end

      def empty?
        @records.empty?
      end

      def model_name
        @headers.first.raw_data[8,18].unpack('Z*')[0]
      end

      def model_number
        @headers.first.raw_data[0].unpack('C')[0] + 1
      end

      def model_type
        case @headers.first.raw_data[1].unpack('C')[0]
        when 0x00
          'Fixed Wing'
        when 0x01
          'Helicopter'
        else
          'Unknown'
        end
      end

    end

  end
end