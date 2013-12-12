require 'spec_helper'

describe User do
  subject { create :user }

  context 'created programatically' do
    it 'to have a short name' do
      expect(subject.short_name.length).to be > 0
    end

    it 'to not be moving' do
      expect(subject.moving?).to be false
    end

    it 'to have a uuid' do
      expect(subject.uuid_str).to match /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    end

    it 'to only create uuid_str once' do
      expect(subject.uuid_str).to be subject.uuid_str
    end

    it 'to have an empty list of user locations' do
      expect(subject.user_locations).to be_a_kind_of Array
    end

    it 'to have no average location' do
      expect(subject.average_location).to be_nil
    end

    it 'moving state not persisted' do
      expect(subject.moving).to be false
    end

    context 'with user locations' do
      subject { create :user_with_locations }

      it 'to have an average location' do
        expect(subject.average_location).to be_a_kind_of Location
      end

      it { expect(subject).to be_moving }

      context 'and is moving' do
        before { subject.moving? }

        it 'moving state persisted' do
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

        it 'to have no average location' do
          expect(subject.average_location).to be_nil
        end
      end

      context 'that are in the same place' do
        subject do 
          user = create :user
          create_list(:user_location, 10, user: user, lat: 1, lng: 2)
          user
        end

        it { expect(subject.moving).to be false }

        it 'to have an average location' do
          expect(subject.average_location).to be_a_kind_of Location
        end
      end
    end
  end

  context 'from db' do
    it 'can be fetched with uuid_str' do
      expect(User.get(subject.uuid_str).uuid_str).to eq subject.uuid_str
    end
  end
end
