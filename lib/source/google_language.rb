# frozen_string_literal: true

module Source
  class GoogleLanguage
    VALID_LANGUAGE_CODES = %w[
      ar hy be bg ca hr cs da nl en eo et tl fi fr de el iw hu is id it ja
      ko lv lt no fa pl pt ro ru sr sk sl es sv th tr uk vi zh-CN zh-TW
    ].freeze

    def initialize(language_code)
      @language_code = language_code
    end

    def code
      raise ArgumentError, "Language code is invalid" unless VALID_LANGUAGE_CODES.include? @language_code

      @language_code
    end
  end
end
