require 'spec_helper'

describe User do
  subject { create :user }
  let(:uuid_str) { subject.uuid_str }
  let(:db_moving_field) { subject.moving }
  let(:newest_location) { subject.newest_location }

  context 'created programatically' do
    it 'should have a short name' do
      expect(subject.short_name.length).to be > 0
    end

    it { expect(subject).not_to be_moving }    
    it { expect(subject).not_to be_active }

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

      it { expect(subject).to be_moving }
      it { expect(subject).to be_active }
      it { expect(newest_location).not_to be_nil }

      context 'and is moving' do
        it 'should have moving state persisted' do
          expect{ subject.moving? }.to change(subject, :moving).from(false).to(true)
        end
      end

      context 'that are old' do
        subject do 
          user = create :user
          create_list(:user_location, 10, :old, user: user)
          user
        end

        it { expect(subject).to be_moving }
        it { expect(subject).not_to be_active }
      end

      context 'that are in the same place' do
        subject do 
          user = create :user
          create_list(:user_location, 10, user: user, lat: 1, lng: 2)
          user
        end      

        it { expect(db_moving_field).to be_falsey }
        it 'should have a newest location' do
          expect(newest_location).not_to be_nil
        end
      end
    end
  end

  context 'from db' do
    let(:user_from_db) { User.get(subject.uuid_str) }

    it 'should be fetched with uuid_str' do
      expect(user_from_db.uuid_str).to eq uuid_str
    end
  end
end
