require 'open-uri'

module Spektrum
  module Log

    class File

      attr_reader :records, :flights

      # Determines if the file at the given URI is a Spektrum telemetry log file.
      # If it is desired to read the file, #new should be used in favor of this, catching any
      # errors that may be raised.
      #
      # @param uri URI to file to read
      # @return [Boolean] true if the file is a Spektrum log file, false otherwise
      def self.spektrum? uri
        !!File.new(uri) rescue false
      end

      def initialize uri
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
                raise ArgumentError, 'File does not appear to be an Spektrum log'
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
        raise ArgumentError, 'File does not appear to be an Spektrum log'
      end

      # Gets the total duration of all flights contained within.
      #
      # @return [Float] total duration of all flights, in seconds
      def duration
        @flights.map(&:duration).reduce(&:+)
      end

    end

  end
end
