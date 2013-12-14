require 'spec_helper'

describe StopTime do
  context 'from csv' do
    let(:row) { build(:stop_time_row, arrival_time: arrival_str) }
    let(:arrival_time_minutes) { subject.arrival }

    context 'time string to minutes' do
      context 'midnight' do
        let(:arrival_str) { '00:00' }
        subject { build :stop_time, stop_time_row: row }
        it { expect(arrival_time_minutes).to eq 0 }
      end

      context '01:00' do
        let(:arrival_str) { '01:00' }
        subject { build :stop_time, stop_time_row: row }
        it { expect(arrival_time_minutes).to eq 60 }
      end

      context '06:00' do
        let(:arrival_str) { '06:00' }
        subject { build :stop_time, stop_time_row: row }
        it { expect(arrival_time_minutes).to eq 360 }
      end

      context '11:59' do
        let(:arrival_str) { '11:59' }
        subject { build :stop_time, stop_time_row: row }
        it { expect(arrival_time_minutes).to eq 719 }
      end

      context '12:00' do
        let(:arrival_str) { '12:00' }
        subject { build :stop_time, stop_time_row: row }
        it { expect(arrival_time_minutes).to eq 720 }
      end

      context '12:01' do
        let(:arrival_str) { '12:01' }
        subject { build :stop_time, stop_time_row: row }
        it { expect(arrival_time_minutes).to eq 721 }
      end

      context '24:00' do
        let(:arrival_str) { '24:00' }
        subject { build :stop_time, stop_time_row: row }
        it { expect(arrival_time_minutes).to eq 1440 }
      end

      context '24:01' do
        let(:arrival_str) { '24:01' }
        subject { build :stop_time, stop_time_row: row }
        it { expect(arrival_time_minutes).to eq 1441 }
      end

      context '25:00' do
        let(:arrival_str) { '25:00' }
        subject { build :stop_time, stop_time_row: row }
        it { expect(arrival_time_minutes).to eq 1500 }
      end
    end
  end
end