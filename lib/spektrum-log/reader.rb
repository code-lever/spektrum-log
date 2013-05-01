module Spektrum
  module Log

    class Reader

      attr_reader :records, :record_count

      def initialize filename
        @headers = []
        @records = []

        File.open(filename, 'rb') do |file|
          loop do
            first4 = file.read(4)
            if first4.nil?
              break
            end

            first = first4.unpack('V')[0]
            if 0xFFFFFFFF == first
              rest = file.read(32)
              @headers << Headers.create(rest)
            else
              type = file.read(1).unpack('C')[0]
              rest = file.read(15)
              @records << Records.create(type, first, rest)
            end
          end
        end

      end

      def duration
        @records.last.time - @records.first.time
      end

    end

  end
end