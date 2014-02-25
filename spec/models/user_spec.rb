require 'spec_helper'

describe User do
  subject { create :user }
  let(:uuid_regex) { /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/ }
  let(:group_radius) { Distanceable::EARTH_DIAMETER }


  context 'created programatically' do
    it { is_expected.not_to be_moving }
    it { is_expected.not_to be_active }
    it { expect( its :short_name, :length ).to be > 0 }
    it { expect( its :uuid_str ).to match uuid_regex }
    it { expect( its :newest_location ).to be_nil }
    it { expect( its :moving_flag ).to be_falsey }

    it 'should only create uuid_str once' do
      expect( its :uuid_str ).to be its :uuid_str
    end

    it 'should have an empty list of user locations' do
      expect( its :user_locations ).to be_a_kind_of Enumerable
      expect( its :user_locations ).to be_empty
    end

    it 'should not be within any bounds' do
      expect( LocationBounds.each(60).any? {|b| subject.within? b } ).to be_falsey
    end


    context 'with no groups' do
      let(:groups) { [] }
      it { expect( subject.closest_group groups, group_radius ).to be_nil }
    end


    context 'with user locations' do
      subject(:user) { create :user_with_locations }
      let(:close_group) do
        lat = user.newest_location.lat + 0.0001
        lng = user.newest_location.lng + 0.0001
        build(:user_group).tap{|g| g << create(:user, lat: lat, lng: lng) }
      end
      let(:groups) do
        [ close_group,
          build(:user_group, count: 1),
          build(:user_group, count: 2),
          build(:user_group, count: 3) ]
      end

      it { is_expected.to be_moving }
      it { is_expected.to be_active }
      it { expect( its :newest_location ).not_to be_nil }

      it 'should not be within some bounds' do
        expect(LocationBounds.each(60).any? {|b| user.within? b }).to be_truthy
      end

      it { expect( user.closest_group groups, group_radius ).to eq close_group }


      context 'and is moving' do
        it 'should have moving state persisted to DB' do
          expect{ subject.moving? }.to change(subject, :moving_flag).from(false).to(true)
        end
      end


      context 'that are old' do
        subject do 
          create(:user).tap {|u| create_list :user_location, 10, :old, user: u }
        end

        it { is_expected.to be_moving }
        it { is_expected.not_to be_active }
      end


      context 'that are in the same place' do
        subject do 
          create(:user).tap {|u| create_list :user_location, 10, user: u, lat: 1, lng: 2 }
        end      

        it { expect( its :moving_flag ).to be_falsey }
        it { expect( its :newest_location ).not_to be_nil }
      end
    end
  end


  context 'from DB' do
    let(:user_from_db) { User.get subject.uuid_str }

    it 'should be fetched with uuid_str' do
      expect( its :uuid_str ).to eq user_from_db.uuid_str
    end
  end
end
