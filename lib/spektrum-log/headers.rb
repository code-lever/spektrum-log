module Spektrum
  module Log

    class Header

      attr_reader :raw_data

      def initialize raw_data
        @raw_data = raw_data
      end

    end

    class Headers

      def self.create raw_data
        Header.new(raw_data)
      end

    end

  end
end