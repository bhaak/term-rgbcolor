require_relative "rgbcolor/version"

module Term
  class RGBColor

    FALLBACK_COLORS = {
      black:   0,
      red:     1,
      green:   2,
      yellow:  3,
      blue:    4,
      magenta: 5,
      cyan:    6,
      white:   7,
    }

    def initialize(r, g, b, bg: false, fallback: nil)
      @r, @g, @b = r ,g, b
      @bg = bg
      @cache = nil
      @fallback = fallback

      @no_color = !ENV['NO_COLOR'].nil?
      @truecolor = (ENV['COLORTERM'] == 'truecolor')
      @@colors ||= `tput colors`.to_i rescue 0
      if !@truecolor && @@colors == 256
        @@colors256 ||= self.class.init_256colors
      end
    end

    def to_s
      return @cache if @cache
      return '' if @no_color

      if @@colors < 256 && !@truecolor
        if @fallback
          return "\e[#{@bg ? '4' : '3'}#{FALLBACK_COLORS.fetch(@fallback)}m"
        else
          return ''
        end
      end

      code = @bg ? '48' : '38'
      if @truecolor
        @cache = "\e[#{code};2;#{@r};#{@g};#{@b}m"
      elsif @@colors256
        color = get_256_color_index(@r, @g, @b)
        @cache = "\e[#{code};5;#{color}m" if color
      end
      @cache ||= ''
    end

    private

    def self.init_256colors
      c = [0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff]
      colors = {}
      for r in (0..5)
        for g in (0..5)
          for b in (0..5)
            colors[(c[r]<<16) + (c[g]<<8) + c[b]] = 16 + r*36 + g*6 + b
          end
        end
      end
      colors
    end

    def get_256_color_index(r, g, b)
      color = (r<<16) + (g<<8) + b
      return @@colors256[color] if @@colors256[color]

      # look for an exact match
      current_index = -1
      previous_match = 2**32
      @@colors256.each {|value, index|
        distance = color_distance(r, g, b, value);
        if (distance < previous_match) then
          previous_match = distance;
          current_index = index
        end
      }
      current_index
    end

    # Calculate the color distance between two colors.
    # Algorithm taken from https://www.compuphase.com/cmetric.htm
    def color_distance(r1, g1, b1, rgb2)
      r2 = (rgb2 >> 16) & 0xFF;
      g2 = (rgb2 >>  8) & 0xFF;
      b2 = (rgb2      ) & 0xFF;

      rmean = (r1 + r2) / 2;
      r = r1 - r2;
      g = g1 - g2;
      b = b1 - b2;
      return ((((512+rmean)*r*r)>>8) + 4*g*g + (((767-rmean)*b*b)>>8));
    end

  end
end
