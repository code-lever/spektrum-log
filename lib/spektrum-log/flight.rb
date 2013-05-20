module Spektrum
  module Log

    class Flight

      attr_reader :headers, :records

      def initialize(headers, records)
        @headers = headers
        @records = records
      end

      def duration
        @duration ||= ((@records.empty? ? 0 : @records.last.timestamp - @records.first.timestamp) / 256)
      end

      def empty?
        @records.empty?
      end

      def bind_type
        @bind_type ||= case @headers.first.raw_data[2].unpack('C')[0]
                       when 0x01..0x02
                         'DSM2'
                       when 0x03..0x04
                         'DSMX'
                       else
                         'Unknown'
                       end
      end

      def model_name
        @model_name ||= @headers.first.raw_data[8..18].unpack('Z*')[0].strip
      end

      def model_number
        @model_number ||= (@headers.first.raw_data[0].unpack('C')[0] + 1)
      end

      def model_type
        @model_type ||= case @headers.first.raw_data[1].unpack('C')[0]
                        when 0x00
                          'Fixed Wing'
                        when 0x01
                          'Helicopter'
                        else
                          'Unknown'
                        end
      end

      def altimeter_records?
        any_records? AltimeterRecord
      end

      def altimeter_records
        select_records AltimeterRecord
      end

      def basic_data_records?
        any_records? BasicDataRecord
      end

      def basic_data_records
        select_records BasicDataRecord
      end

      def flight_log_records?
        any_records? FlightLogRecord
      end

      def flight_log_records
        select_records FlightLogRecord
      end

      def g_force_records?
        any_records? GForceRecord
      end

      def g_force_records
        select_records GForceRecord
      end

      def gps1_records?
        any_records? GPSRecord1
      end

      def gps1_records
        select_records GPSRecord1
      end

      def gps2_records?
        any_records? GPSRecord2
      end

      def gps2_records
        select_records GPSRecord2
      end

      def speed_records?
        any_records? SpeedRecord
      end

      def speed_records
        select_records SpeedRecord
      end

      private

      def any_records?(type)
        @records.any? { |rec| rec.is_a? type }
      end

      def select_records(type)
        @records.select { |rec| rec.is_a? type }
      end

    end

  end
end
