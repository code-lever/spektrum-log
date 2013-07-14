require 'ruby_kml'

module Spektrum
  module Log

    # Represents a single recorded flight.  Contains information about the model
    # flown, duration of the flight, and all data records contained within.
    class Flight

      attr_reader :headers, :records

      # Creates a new flight.
      #
      # @param headers [Array<Header>] headers read from the file
      # @param records [Array<Record>] records read from the file
      def initialize(headers, records)
        @headers = headers
        @records = records
      end

      # Gets the duration of the flight, in seconds.
      #
      # @return [Float] duration of the flight, in seconds
      def duration
        @duration ||= timestamp_delta / 256.0
      end

      # Determines if this flight has any data.  Models without telemetry
      # transmitted, but with logging enabled will create empty flights.
      #
      # @return [Boolean] true if the flight has no records, false otherwise
      def empty?
        @records.empty?
      end

      # Gets the binding type the flight was flown with.
      #
      # @return [String] binding type of the flight, `DSM2`, `DSMX`, etc.
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

      # Gets the name of the model for this flight.
      #
      # @return [String] model name
      def model_name
        @model_name ||= @headers.first.raw_data[8..27].unpack('Z*')[0].strip
      end

      # Gets the model's index from the transmitter.
      #
      # @return [Fixnum] model number
      def model_number
        @model_number ||= (@headers.first.raw_data[0].unpack('C')[0] + 1)
      end

      # Gets the type of model flown.
      #
      # @return [String] model type
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

      # Gets the type of telemetry unit that sent the data.
      #
      # @return [String] telemetry unit
      def telemetry_unit
        @telemetry_unit ||= derive_telemetry_unit
      end

      # Gets the difference between the last and the first timestamps.  May
      # be zero if no records exist.
      #
      # @return [Number] difference between the last and first timestamp
      def timestamp_delta
        @timestamp_delta ||= @records.empty? ? 0.0 : (@records.last.timestamp - @records.first.timestamp)
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

      def to_kml?
        gps1_records?
      end

      def to_kml
        raise RuntimeError, 'No coordinates available for KML generation' unless to_kml?
        to_kml_file.render
      end

      def to_kml_file
        kml = KMLFile.new
        kml.objects << KML::Document.new(
          :name => 'Spektrum TLM GPS Path',
          :description => 'Flight paths for GPS telemetry data',
          :styles => [
            KML::Style.new(
              :id => 'yellowLineGreenPoly',
              :line_style => KML::LineStyle.new(:color => '7F00FFFF', :width => 4),
              :poly_style => KML::PolyStyle.new(:color => '7F00FF00')
            )
          ],
          :features => [ to_kml_placemark ]
        )
        kml
      end

      def to_kml_placemark
        KML::Placemark.new(
          :name => "#{model_name} (#{duration.round(1)}s)",
          :style_url => '#yellowLineGreenPoly',
          :geometry => KML::LineString.new(
            :extrude => true,
            :tessellate => true,
            :altitude_mode => 'absolute',
            :coordinates => gps1_records.map(&:coordinate).map { |c| c.join(',') }.join(' ')
          )
        )
      end

      private

      # Determines if there are any records in this flight of the given type.
      #
      # @param type [Class] type of record to check for
      # @return [Boolean] true if there are valid records, false otherwise
      def any_records?(type)
        @records.any? { |rec| rec.is_a?(type) && rec.valid? }
      end

      def derive_telemetry_unit
        return "None" unless basic_data_records? && flight_log_records?
        key = [basic_data_records.first.type, flight_log_records.first.type]
        types = { [0x7E, 0x7F] => 'TM1000', [0xFE, 0xFF] => 'TM1100' }
        types.fetch(key, 'Unknown')
      end

      def select_records(type)
        @records.select { |rec| rec.is_a?(type) && rec.valid? }
      end

    end

  end
end
