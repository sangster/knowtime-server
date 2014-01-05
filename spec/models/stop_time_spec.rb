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
end