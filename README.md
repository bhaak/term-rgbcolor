# Term::RGBColor

Ruby library for outputting RGB colors on the terminal with automatic
fallbacks.

It also provides `Term::ANSIColor` for the standard ANSI colors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'term-rgbcolor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install term-rgbcolor

## Usage

### RGB colors

`Term::RGBColor` emits 24-bit color escape sequences when the terminal
advertises truecolor support via `COLORTERM=truecolor`. Otherwise it falls
back to the nearest 256-color sequence.

```ruby
require "term/rgbcolor"

puts "#{Term::RGBColor.new(255, 128, 0)}orange text\e[0m"
puts "#{Term::RGBColor.new(255, 128, 0, bg: true)}orange background\e[0m"
```

On terminals without 256-color support, an ANSI fallback color can be
specified:

```ruby
puts "#{Term::RGBColor.new(255, 128, 0, fallback: :red)}orange text\e[0m"
```

### ANSI colors

`Term::ANSIColor` supports the eight standard ANSI colors and their bright
variants.

```ruby
require "term/ansi_color"

puts "#{Term::ANSIColor.new(:red)}red text\e[0m"
puts "#{Term::ANSIColor.new(:green, bg: true)}green background\e[0m"
puts "#{Term::ANSIColor.new(:bright_blue)}bright blue text\e[0m"
```

Available color names are `:black`, `:red`, `:green`, `:yellow`, `:blue`,
`:magenta`, `:cyan`, and `:white`, plus the bright variants `:bright_black`
through `:bright_white`. Only symbols are accepted; unknown names raise an
`ArgumentError`.

On terminals with fewer than 16 colors, bright colors fall back to their
normal variant. Terminals without color support produce no escape sequence.

### Disabling colors

Both classes honor the [`NO_COLOR`](https://no-color.org/) environment
variable. If it is set, `to_s` returns an empty string:

```ruby
ENV["NO_COLOR"] = "1"
Term::RGBColor.new(255, 128, 0).to_s # => ""
```

The caller is responsible for resetting the terminal attributes, e.g. with
`"\e[0m"`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bhaak/term-rgbcolor.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
