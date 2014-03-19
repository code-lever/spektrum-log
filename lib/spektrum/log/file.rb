require 'open-uri'

module Spektrum
  module Log

    class File

      attr_reader :records, :flights

      # Determines if the file at the given URI is a Spektrum telemetry log file.
      #
      # @param uri URI to file to read
      # @return [Spektrum::Log::File] loaded file if the file is a Spektrum log file, nil otherwise
      def self.spektrum?(uri)
        File.new(uri) rescue nil
      end

      def initialize(uri)
        headers = []
        headers_complete = false
        records = []
        @flights = []

        first_word = true

        open(uri, 'rb') do |file|
          loop do
            first4 = file.read(4)

            # quick check to see if this could even be a Spektrum TLM file
            if first_word
              if first4.nil? || (0xFFFFFFFF != first4.unpack('V')[0])
                raise ArgumentError, 'File does not appear to be a Spektrum log'
              end
              first_word = false
            end

            if first4.nil?
              if headers_complete || !records.empty?
                # we have records, this is a new entry
                @flights << Flight.new(headers, records)
                headers = []
                records = []
              end
              break
            end

            first = first4.unpack('V')[0]
            if 0xFFFFFFFF == first
              if headers_complete || !records.empty?
                # we have records, this is a new entry
                @flights << Flight.new(headers, records)
                headers = []
                records = []
                headers_complete = false
              end

              rest = file.read(32)
              headers << Headers.create(rest)

              headers_complete = rest.unpack('S')[0] == 0x1717
            else
              data = file.read(16)
              type = data[0].unpack('C')[0]
              records << Records.create(type, first, data)
            end
          end
        end
      rescue
        raise ArgumentError, 'File does not appear to be a Spektrum log'
      end

      # Gets the total duration of all flights contained within.
      #
      # @return [Float] total duration of all flights, in seconds
      def duration
        @flights.map(&:duration).reduce(&:+)
      end

      # Determines if KML methods can be called for this file.
      #
      # @return [Boolean] true if KML can be generated for this file, false otherwise
      def to_kml?
        @flights.any?(&:to_kml?)
      end

      # Converts the file into a KML document containing placemarks for each
      # flight containing GPS data.
      #
      # @param options [Hash] hash containing options for file
      # @return [String] KML document for all applicable flights in the file
      # @see #to_kml_file file options
      def to_kml(options = {})
        raise RuntimeError, 'No coordinates available for KML generation' unless to_kml?
        to_kml_file(options).render
      end

      # Converts the file into a KMLFile containing placemarks for each flight containing
      # GPS data.
      #
      # @param options [Hash] hash containing options for file
      # @option options [String] :name name option of KML::Document
      # @option options [String] :description name option of KML::Document
      # @return [KMLFile] file for the flight
      def to_kml_file(options = {})
        raise RuntimeError, 'No coordinates available for KML generation' unless to_kml?
        options = apply_default_file_options(options)

        style = 'kmlfile-style-id'
        kml_flights = @flights.select(&:to_kml?)
        marks = kml_flights.each_with_object({ :style_url => "##{style}" }).map(&:to_kml_placemark)

        kml = KMLFile.new
        kml.objects << KML::Document.new(
          :name => options[:name],
          :description => options[:description],
          :styles => [
            KML::Style.new(
              :id => style,
              :line_style => KML::LineStyle.new(:color => '7F00FFFF', :width => 4),
              :poly_style => KML::PolyStyle.new(:color => '7F00FF00')
            )
          ],
          :features => marks
        )
        kml
      end

      private

      def apply_default_file_options(options)
        options = { :name => 'Spektrum TLM GPS Path' }.merge(options)
        options = { :description => 'Flight paths for GPS telemetry data' }.merge(options)
        options
      end

    end

  end
end
