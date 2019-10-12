require_relative "rgbcolor/version"

module Term
  class RGBColor

    def initialize(r, g, b, bg: false)
      @r, @g, @b = r ,g, b
      @bg = bg
    end

    def to_s
      code = @bg ? '48' : '38'
      "\e[#{code};2;#{@r};#{@g};#{@b}m"
    end

  end
end
