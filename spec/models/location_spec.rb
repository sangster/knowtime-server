require 'spec_helper'

describe Location do
  context 'two equal locations with no time' do
    subject { [Location.new(1, 2, nil), Location.new(1, 2, nil)] }

    it { expect( its :first ).to eq its :second }
  end

  context 'two equal locations with same time' do
    before(:each) do
      allow( DateTime ).to receive( :now ) { DateTime.parse '2013-12-13 12:13:14' }
    end

    subject {[ Location.new(1, 2), Location.new(1, 2) ]}

    it { expect(subject.first).to eq subject.second }
  end
end

describe Location, '#each' do
  it { expect( Location.each ).to be_a_kind_of Enumerable }
  it { expect( Location.each.count ).to eq( (360+1)*(180+1) ) }
  it { expect( Location.each(15).count ).to eq( 13*25 ) }
end