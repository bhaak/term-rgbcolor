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

    before :each do
      allow(ENV).to receive(:[]).and_return nil
      Term::RGBColor.class_variable_set(:@@colors, nil)
    end

    describe '24 bit color support' do
      before :each do
        expect(ENV).to receive(:[]).with('COLORTERM').and_return 'truecolor'
      end

      it 'returns a foreground RGB escape sequence' do
        expect("#{Term::RGBColor.new(r,g,b)}").to eq "\e[38;2;80;160;240m"
      end

      it 'returns a background RGB escape sequence' do
        expect("#{Term::RGBColor.new(r,g,b, bg: true)}").to eq "\e[48;2;80;160;240m"
      end

      describe 'with the enviromental variable NO_COLOR' do
        before :each do
          expect(ENV).to receive(:[]).with('NO_COLOR').and_return ''
        end

        it 'returns the empty string' do
          expect("#{Term::RGBColor.new(r,g,b)}").to eq ""
        end
      end
    end

    describe 'without 24 bit color support' do
      before :each do
        allow_any_instance_of(Kernel).to receive(:`).and_return 256
      end

      it 'falls back to 256 color escape sequences' do
        expect("#{Term::RGBColor.new(255,215,135)}").to eq "\e[38;5;222m"
        expect("#{Term::RGBColor.new( 95,175,135)}").to eq "\e[38;5;72m"
      end

      describe 'with RGB values not exactly equal to a 256 color escape sequence' do
        it 'returns a close match' do
          expect("#{Term::RGBColor.new(250,210,130)}").to eq "\e[38;5;222m"
          expect("#{Term::RGBColor.new(100,180,140)}").to eq "\e[38;5;72m"
        end
      end
    end

    describe 'without 256 color support' do
      before :each do
        allow_any_instance_of(Kernel).to receive(:`).and_return nil
      end

      it 'returns an empty string' do
        expect("#{Term::RGBColor.new(255,215,135)}").to eq ''
      end

      describe 'with a fallback color defined' do
        it 'returns the fallback color' do
          expect("#{Term::RGBColor.new(1,1,1, fallback: :red)}").to eq "\e[31m"
          expect("#{Term::RGBColor.new(1,1,1, fallback: :red, bg: true)}").to eq "\e[41m"
        end
      end
    end

  end

end
