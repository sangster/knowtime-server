require 'spec_helper'

describe Calendar do
  context 'for_date' do
    before do
      @weekday = create :calendar, weekday: true, saturday: false, sunday: false
      @saturday = create :calendar, weekday: false, saturday: true, sunday: false
      @sunday = create :calendar, weekday: false, saturday: false, sunday: true
    end

    it 'should match by day of the week' do
      expect( Calendar.for_date DateTime.parse('2014-01-03') ).to match_array([@weekday])
      expect( Calendar.for_date DateTime.parse('2014-01-04') ).to match_array([@saturday])
      expect( Calendar.for_date DateTime.parse('2014-01-05') ).to match_array([@sunday])
    end
  end

  context 'for_date_params' do
    before do
      @weekday = create :calendar, weekday: true, saturday: false, sunday: false
      @saturday = create :calendar, weekday: false, saturday: true, sunday: false
      @sunday = create :calendar, weekday: false, saturday: false, sunday: true
    end

    it 'should match by day of the week' do
      expect( Calendar.for_date_params(year: '2014', month: '01', day: '03') ).to match_array([@weekday])
      expect( Calendar.for_date_params(year: '2014', month: '01', day: '04') ).to match_array([@saturday])
      expect( Calendar.for_date_params(year: '2014', month: '01', day: '05') ).to match_array([@sunday])
    end
  end
end
