require 'spec_helper'

describe Stop do
  before :each do
  	@stop = build :stop
  end

  context 'normal' do
  	it { expect(@stop.lat).to eq 44.669369 }
  	it { expect(@stop.lng).to eq -63.655807 }


  end

  describe :location do
  	it do
  		loc = Location.new 44.669369, -63.655807
  		expect(@stop.location.lat).to eq loc.lat
  		expect(@stop.location.lng).to eq loc.lng
  	end  
  	
  	it :change do 
  		expect{ @stop.location = Location.new(10, 20) }.
  		to change{ @stop.location.lat}.to 10
  		expect{ @stop.location = Location.new(10, 20) }.
  		to change{ @stop.location.lng}.to 21
  	end	
  end

  context 
end
