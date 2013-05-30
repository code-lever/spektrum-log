require 'open-uri'

module Spektrum
  module Log

    class Reader

      attr_reader :records, :flights

      def initialize uri
        headers = []
        headers_complete = false
        records = []
        @flights = []

        open(uri, 'rb') do |file|
          loop do
            first4 = file.read(4)
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
              type = file.read(1).unpack('C')[0]
              rest = file.read(15)
              records << Records.create(type, first, rest)
            end
          end
        end

      end

    end

  end
end
