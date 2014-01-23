require 'spec_helper'

describe StopTime do
  context 'from csv' do
    let(:row) { build(:stop_time_row, arrival_time: arrival_str) }
    subject { build :stop_time, stop_time_row: row }

    describe 'time string to minutes' do
      context 'at midnight' do
        let( :arrival_str ) { '00:00' }
        it { expect( its :arrival ).to eq 0 }
      end

      context 'at 01:00' do
        let( :arrival_str ) { '01:00' }
        it { expect( its :arrival ).to eq 60 }
      end

      context 'at 06:00' do
        let( :arrival_str ) { '06:00' }
        it { expect( its :arrival ).to eq 360 }
      end

      context 'at 11:59' do
        let( :arrival_str ) { '11:59' }
        it { expect( its :arrival ).to eq 719 }
      end

      context 'at 12:00' do
        let( :arrival_str ) { '12:00' }
        it { expect( its :arrival ).to eq 720 }
      end

      context 'at 12:01' do
        let( :arrival_str ) { '12:01' }
        it { expect( its :arrival ).to eq 721 }
      end

      context 'at 24:00' do
        let( :arrival_str ) { '24:00' }
        it { expect( its :arrival ).to eq 1440 }
      end

      context 'at 24:01' do
        let( :arrival_str ) { '24:01' }
        it { expect( its :arrival ).to eq 1441 }
      end

      context 'at 25:00' do
        let( :arrival_str ) { '25:00' }
        it { expect( its :arrival ).to eq 1500 }
      end
    end
  end

  describe '#next_stops' do
    let(:route) { create :route }
    let(:calendar) { create :calendar }
    let(:time) { Time.zone.parse (calendar.start_date + 1.month).strftime('%c') }
    let(:short_name) { route.short_name }

    subject { StopTime.next_stops short_name, time }

    context 'with 2 stops at the same bus stop on different trips' do
      let(:stop_1) { create :stop_time, stop_time_row: build(:stop_time_row, stop_id: "10" ) }
      let(:stop_2) { create :stop_time, stop_time_row: build(:stop_time_row, stop_id: "10" ) }

      before do
        stop_1.trip.route = route
        stop_1.trip.save!
        stop_2.trip.route = route
        stop_2.trip.save!

        calendar.trips << stop_1.trip << stop_2.trip
        calendar.save!
      end

      it { expect( its :size ).to eq 1 }
      it { expect( its :first, :id ).to eq stop_1.id }
      it { expect( its :first, :id ).not_to eq stop_2.id }
    end

    context 'with 2 stops on the same trip' do
      let(:stop_1) { create :stop_time, stop_time_row: build(:stop_time_row) }
      let(:stop_2) { create :stop_time, stop_time_row: build(:stop_time_row) }

      before do
        build(:trip).tap do |t|
          t.stop_times << stop_1
          t.stop_times << stop_2
          Trip.all.delete # the factory StopTimes come with their own trips

          t.route = route
          calendar.trips << t
          calendar.save!
        end.save!
      end

      it { expect( its :size ).to eq 1 }
      it { expect( its :first, :id ).to eq stop_1.id }
      it { expect( its :first, :id ).not_to eq stop_2.id }
    end
  end
end
