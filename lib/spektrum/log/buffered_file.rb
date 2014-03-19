require 'open-uri'

module Spektrum
  module Log

    class BufferedFile

      def initialize(uri, mode)
        @io = open(uri, mode)
        @buffer = StringIO.new
      end

      def read(length)
        fetch_chunk if (@buffer.length - @buffer.pos) < length
        @buffer.read(length)
      end

      def close
        @buffer = nil
        @io.close
      end

      private

      def fetch_chunk
        @buffer = StringIO.new.tap do |b|
          b << @buffer.read
          b << @io.read(4096)
          b.seek(0)
        end
      end

    end

  end
end
