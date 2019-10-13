require_relative "rgbcolor/version"

module Term
  class RGBColor

    def initialize(r, g, b, bg: false)
      @r, @g, @b = r ,g, b
      @bg = bg

      @no_color = !ENV['NO_COLOR'].nil?
      @truecolor = (ENV['COLORTERM'] == 'truecolor')
      @@colors ||= `tput colors`.to_i rescue 0
      if !@truecolor && @@colors == 256
        @@colors256 ||= self.class.init_256colors
      end
    end

    def to_s
      return '' if @no_color
      return '' unless @truecolor || @@colors >= 256

      code = @bg ? '48' : '38'
      if @truecolor
        return "\e[#{code};2;#{@r};#{@g};#{@b}m"
      elsif @@colors256
        color = @@colors256[(@r<<16)+(@g<<8)+@b]
        return "\e[#{code};5;#{color}m" if color
      end
      ''
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

  end
end
