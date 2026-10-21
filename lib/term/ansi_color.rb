module Term
  # Represents one of the 16 standard ANSI terminal colors and renders it as
  # an escape sequence.
  #
  #   Term::ANSIColor.new(:red).to_s             # => "\e[31m"
  #   Term::ANSIColor.new(:red, bg: true).to_s   # => "\e[41m"
  #   Term::ANSIColor.new(:red, bright: true).to_s # => "\e[91m"
  #   Term::ANSIColor.new(:red, bg: true, bright: true).to_s # => "\e[101m"
  class ANSIColor
    COLORS = {
      black:           0,
      red:             1,
      green:           2,
      yellow:          3,
      blue:            4,
      magenta:         5,
      cyan:            6,
      white:           7,
      bright_black:    8,
      bright_red:      9,
      bright_green:   10,
      bright_yellow:  11,
      bright_blue:    12,
      bright_magenta: 13,
      bright_cyan:    14,
      bright_white:   15,
    }.freeze

    attr_reader :index

    def initialize(color, bg: false, bright: false)
      @index = COLORS.fetch(color) do
        raise ArgumentError, "unknown ANSI color: #{color.inspect}"
      end
      @bg = bg
      @bright = bright || @index >= 8
      @cache = nil
      @no_color = !ENV['NO_COLOR'].nil?
    end

    def self.colors
      @@colors ||= `tput colors`.to_i rescue 0
    end

    def to_s
      return @cache if @cache
      return @cache = '' if @no_color
      return @cache = '' if self.class.colors < 8

      # Bright colors need support for at least 16 colors.
      bright = @bright && self.class.colors >= 16
      base = @index % 8
      code = if @bg
               bright ? 100 + base : 40 + base
             else
               bright ? 90 + base : 30 + base
             end
      @cache = "\e[#{code}m"
    end
  end
end
