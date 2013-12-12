require 'spec_helper'

describe User do
  subject { create :user }

  context 'created programatically' do
    it 'should have a short name' do
      expect(subject.short_name.length).to be > 0
    end

    it 'should not be moving' do
      expect(subject.moving?).to be false
    end

    it 'should have a uuid' do
      expect(subject.uuid_str).to match /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    end

    it 'should only create uuid_str once' do
      expect(subject.uuid_str).to be subject.uuid_str
    end

    it 'should have an empty list of user locations' do
      expect(subject.user_locations).to be_a_kind_of Array
    end

    it 'should have no newest location' do
      expect(subject.newest_location).to be_nil
    end

    it 'moving state not persisted' do
      expect(subject.moving).to be false
    end

    context 'with user locations' do
      subject { create :user_with_locations }

      it 'should have an newest location' do
        expect(subject.newest_location).to be_a_kind_of UserLocation
      end

      it { expect(subject).to be_moving }

      context 'and is moving' do
        before { subject.moving? }

        it 'should have moving state persisted' do
          expect(subject.moving).to be true
        end
      end

      context 'that are old' do
        subject do 
          user = create :user
          create_list(:user_location, 10, :old, user: user)
          user
        end

        it { expect(subject).to be_moving }
      end

      context 'that are in the same place' do
        subject do 
          user = create :user
          create_list(:user_location, 10, user: user, lat: 1, lng: 2)
          user
        end

        it { expect(subject.moving).to be false }

        it 'should have an newest location' do
          expect(subject.newest_location).to be_a_kind_of UserLocation
        end
      end
    end
  end

  context 'from db' do
    it 'should be fetched with uuid_str' do
      expect(User.get(subject.uuid_str).uuid_str).to eq subject.uuid_str
    end
  end
end
