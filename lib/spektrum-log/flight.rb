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

    end

  end
end