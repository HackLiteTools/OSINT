# frozen_string_literal: true

require "net/http"

module Source
  class LocalSource
    def initialize(filename)
      @filename = filename
    end

    def responses(_phrase)
      file = File.open(@filename)
      begin
        [file.read]
      ensure
        file.close
      end
    end
  end
end
