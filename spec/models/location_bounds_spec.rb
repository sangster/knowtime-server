require 'spec_helper'

describe LocationBounds do
  context 'empty bounds' do
    subject { LocationBounds.new greenwich, greenwich }

    let(:greenwich) { Location.new 0.0, 0.0 }
    let(:ne_of_greenwich) { Location.new 0.001, 0.001 }
    let(:sw_of_greenwich) { Location.new -0.001, -0.001 }

    it{ expect( subject.lat_range ).to eq 0.0..0.0 }
    it{ expect( subject.lng_range ).to eq 0.0..0.0 }
    it{ expect( subject ).to cover greenwich }
    it{ expect( subject ).not_to cover ne_of_greenwich }
    it{ expect( subject ).not_to cover sw_of_greenwich }
  end
end
