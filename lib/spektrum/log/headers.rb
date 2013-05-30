module Spektrum
  module Log

    # Represents a single header from the telemetry file.
    class Header

      attr_reader :raw_data

      # Creates a new header.
      #
      # @param [String] raw_data string of data from the data file for this header
      def initialize raw_data
        @raw_data = raw_data
      end

    end

    # Helper class to create the correct type of header for the given data.
    class Headers

      def self.create raw_data
        Header.new(raw_data)
      end

    end

  end
end
