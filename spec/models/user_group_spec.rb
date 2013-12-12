require 'spec_helper'

describe UserGroup do
  context 'created programatically' do
    subject { build :user_group }
    let(:user) { create :user_with_locations }

    it { expect(subject.users).to be_empty }

    it 'should have no location' do
      expect(subject.location).to be_nil
    end

    it 'should have NaN latitude' do
      expect(subject.lat).to be Float::NAN
    end

    it 'should have NaN longitude' do
      expect(subject.lng).to be Float::NAN
    end

    it { expect{ subject << user }.to change(subject, :location).from(nil) }

    context 'with active users' do
      subject { build :user_group, count: 5 }

      it 'has the correct number of users' do
        expect(subject.users.length).to be 5
      end

      it 'should have a location' do
        expect(subject.location).not_to be_nil
      end

      it 'should have correct latitude' do
        expect(subject.lat).to be subject.location.lat
      end

      it 'should have correct longitude' do
        expect(subject.lng).to be subject.location.lng
      end

      it { expect{ subject << create(:user) }.to change(subject, :location) }
    end

    context 'with inactive users' do
      subject do
        build(:user_group).tap do |g|
          g.users = 10.times.collect do
            create(:user).tap { |u| create_list(:user_location, 10, :old, user: u) }
          end
        end
      end

      let(:new_user) { create(:user).tap { |u| create_list(:user_location, 10, :old, user: u) } }

      it 'has the correct number of users' do
        expect(subject.users.length).to be 10
      end

      it 'should have no location' do
        expect(subject.location).to be_nil
      end

      it 'should have NaN latitude' do
        expect(subject.lat).to be Float::NAN
      end

      it 'should have NaN longitude' do
        expect(subject.lng).to be Float::NAN
      end

      it do
        expect{ subject << new_user }.not_to change(subject, :location)
      end
    end
  end
end