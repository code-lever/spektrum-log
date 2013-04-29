require "spektrum-log/version"

module Spektrum
  module Log

    class Record

      attr_reader :time

      def self.create type, time, data
        case type
        when 0x00
          #puts "Unknown 00"
          Record.new(time)
        when 0x16
          #puts "#{time} Sixteen"
          Record.new(time)
        when 0x17
          #puts "#{time} Seventeen"
          Record.new(time)
        when 0x7E
          #puts "#{time} Seven-eee"
          Record.new(time)
        when 0x7F
          #puts "#{time} Seven-eff"
          BasicData.new(time, data)
        else
          #puts "#{time} Dunno, was #{type}"
          Record.new(time)
        end
      end

      def initialize time
        @time = time
      end
    end

    class BasicData < Record
      def initialize time, data
        super time
      end
    end

    class Reader

      attr_reader :records

      def initialize filename
        @records = []

        File.open(filename, 'rb') do |file|
          loop do
            first4 = file.read(4)
            if first4.nil?
              break
            end

            first = first4.unpack('L')[0]
            if 0xFFFFFFFF == first
              rest = file.read(32)
            else
              type = file.read(1).unpack('C')[0]
              rest = file.read(15)
              @records << Record.create(type, first, rest)
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
