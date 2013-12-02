require 'spec_helper'

describe Stop do
  subject { build :stop }

  context 'created from CSV' do
    subject do
      build(:stop, :from_csv, 
        name: 'robie Bvld Dr Ave Rd St To Pk Terr Ct Pkwy Hwy Lane Way Entrance Entr.') \
      .name
    end

    it('should capitalize first char') { should match /R.+/ }

    it 'should lower street types' do
      should eq 'Robie bvld dr ave rd st to pk terr ct pkwy hwy lane way entrance entr.'
    end
  end

  context 'created programatically' do
    it('check lat') { expect(subject.lat).to eq 44.669369 }
    it('check lng') { expect(subject.lng).to eq -63.655807 }
  end

  describe :location do
    it 'should have correct lat/lng' do
      expect(subject.location).to eq Location.new(44.669369, -63.655807, nil)
    end
  end  

  it :change do 
    expect{ subject.location = Location.new(10, 20) }.
    to change{ [subject.location.lat, subject.location.lng]}.
    to [10, 20]
  end	
end
