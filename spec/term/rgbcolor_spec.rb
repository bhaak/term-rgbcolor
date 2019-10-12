require "spec_helper"

RSpec.describe Term::RGBColor do
  it "has a version number" do
    expect(Term::RGBColor::VERSION).not_to be nil
  end

  it "has a constructor" do
    expect(Term::RGBColor.new(0,0,0)).to be
  end

  describe "#to_s" do
    let(:r) {  80 }
    let(:g) { 160 }
    let(:b) { 240 }

    it 'returns a foreground RGB escape sequence' do
      expect("#{Term::RGBColor.new(r,g,b)}").to eq "\e[38;2;80;160;240m"
    end

    it 'returns a background RGB escape sequence' do
      expect("#{Term::RGBColor.new(r,g,b, bg: true)}").to eq "\e[48;2;80;160;240m"
    end
  end

end
