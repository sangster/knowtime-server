require 'spec_helper'

describe LocationBounds do
  context 'empty bounds' do
    subject { LocationBounds.new greenwich, greenwich }

    let(:greenwich) { Location.new 0.0, 0.0 }
    let(:ne_of_greenwich) { Location.new 0.001, 0.001 }
    let(:sw_of_greenwich) { Location.new -0.001, -0.001 }

    it{ expect( subject.lat_range ).to eq 0.0..0.0 }
    it{ expect( subject.lng_range ).to eq 0.0..0.0 }
    it{ is_expected.to cover greenwich }
    it{ is_expected.not_to cover ne_of_greenwich }
    it{ is_expected.not_to cover sw_of_greenwich }
  end
end

describe LocationBounds, '#each' do
  it { expect(LocationBounds.each).to be_a_kind_of Enumerable }
  it { expect(LocationBounds.each(60).count).to eq (28 * 28) }
end