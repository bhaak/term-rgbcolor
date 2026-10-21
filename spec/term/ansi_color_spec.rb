require "spec_helper"
require "term/ansi_color"

RSpec.describe Term::ANSIColor do
  before :each do
    allow(ENV).to receive(:[]).and_return nil
    allow(Term::ANSIColor).to receive(:colors).and_return 256
  end

  it "has a constructor" do
    expect(Term::ANSIColor.new(:red)).to be
  end

  describe "#to_s" do
    {
      black:           30,
      red:             31,
      green:           32,
      yellow:          33,
      blue:            34,
      magenta:         35,
      cyan:            36,
      white:           37,
      bright_black:    90,
      bright_red:      91,
      bright_green:    92,
      bright_yellow:   93,
      bright_blue:     94,
      bright_magenta:  95,
      bright_cyan:     96,
      bright_white:    97,
    }.each do |name, code|
      it "returns the foreground escape sequence for #{name}" do
        expect(Term::ANSIColor.new(name).to_s).to eq "\e[#{code}m"
      end
    end

    it "returns a background escape sequence" do
      expect(Term::ANSIColor.new(:red, bg: true).to_s).to eq "\e[41m"
      expect(Term::ANSIColor.new(:bright_red, bg: true).to_s).to eq "\e[101m"
    end

    it "returns a bright escape sequence" do
      expect(Term::ANSIColor.new(:red, bright: true).to_s).to eq "\e[91m"
      expect(Term::ANSIColor.new(:red, bg: true, bright: true).to_s).to eq "\e[101m"
    end

    describe "on a terminal with only 8 colors" do
      before :each do
        allow(Term::ANSIColor).to receive(:colors).and_return 8
      end

      it "returns the normal foreground escape sequence" do
        expect(Term::ANSIColor.new(:red).to_s).to eq "\e[31m"
      end

      it "falls back to the normal color for bright colors" do
        expect(Term::ANSIColor.new(:bright_red).to_s).to eq "\e[31m"
        expect(Term::ANSIColor.new(:red, bright: true).to_s).to eq "\e[31m"
        expect(Term::ANSIColor.new(:red, bg: true, bright: true).to_s).to eq "\e[41m"
      end
    end

    describe "on a terminal without color support" do
      before :each do
        allow(Term::ANSIColor).to receive(:colors).and_return 0
      end

      it "returns the empty string" do
        expect(Term::ANSIColor.new(:red).to_s).to eq ""
        expect(Term::ANSIColor.new(:bright_red).to_s).to eq ""
      end
    end

    describe "with the environmental variable NO_COLOR" do
      before :each do
        allow(ENV).to receive(:[]).with('NO_COLOR').and_return ''
      end

      it "returns the empty string" do
        expect(Term::ANSIColor.new(:red).to_s).to eq ""
      end
    end

    describe "with an invalid color" do
      it "raises an ArgumentError for an unknown name" do
        expect { Term::ANSIColor.new(:pink) }.to raise_error(ArgumentError)
      end

      it "raises an ArgumentError for a value that is not a symbol" do
        expect { Term::ANSIColor.new("red") }.to raise_error(ArgumentError)
        expect { Term::ANSIColor.new(1) }.to raise_error(ArgumentError)
      end
    end
  end
end
