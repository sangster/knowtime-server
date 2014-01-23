require 'spec_helper'

describe UserGroup do
  context 'created programatically' do
    subject { build :user_group }
    let(:user) { create :user_with_locations }

    it { expect( its :users ).to be_empty }
    it { expect( its :location ).to be_nil }
    it { expect( its :lat ).to be Float::NAN }
    it { expect( its :lng ).to be Float::NAN }
    it { expect{ subject << user }.to change(subject, :location).from(nil) }

    it 'can chain <<' do
      expect do
        subject << create(:user) << create(:user)
      end.to change(subject, :count).from(0).to(2)
    end


    context 'with active users' do
      let(:new_user) { create :user, lat: 100, lng: 100 }
      subject { build :user_group, count: 5 }

      it { expect( its :count ).to be 5 }
      it { expect( its :location ).not_to be_nil }
      it { expect( its :lat ).to be subject.location.lat }
      it { expect( its :lng ).to be subject.location.lng }
      it { expect{ subject << new_user }.to change(subject, :location) }
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

      it { expect( its :count ).to be 10 }
      it { expect( its :location ).to be_nil }
      it { expect( its :lat ).to be Float::NAN }
      it { expect( its :lng ).to be Float::NAN }

      it 'should still have no location when an inactive user is added' do
        expect{ subject << new_user }.not_to change(subject, :location)
      end
    end
  end
end


describe UserGroup, '#create_groups' do
  subject { UserGroup.create_groups users, bounds: bounds, radius: radius }
  let(:bounds) { nil }
  let(:radius) { UserGroup::GROUP_RADIUS }

  let(:immobile_users) { 10.times.collect { create(:user) } }
  let(:inactive_users) do
    10.times.collect do
      create(:user).tap {|u| create_list :user_location, 10, :old, user: u }
    end
  end
  let!(:active_user_1) { create(:user).tap {|u| create_list :user_location, 10, user: u } }
  let!(:active_user_2) { create(:user).tap {|u| create_list :user_location, 10, user: u } }


  context 'with no users' do
    let(:users) { [] }
    it { is_expected.to be_empty }
  end


  context 'with no active users' do
    let(:users) { inactive_users }
    it { is_expected.to be_empty }
  end


  context 'with no moving users' do
    let(:users) { immobile_users }
    it { is_expected.to be_empty }
  end


  context 'with one active users' do
    let(:users) { immobile_users + [active_user_1] }

    it { expect( its :count ).to eq 1 }
  end


  context 'with two active users' do
    let(:users) { immobile_users + [active_user_1, active_user_2] }

    context 'who are close enough' do
      let(:radius) { Distanceable::EARTH_DIAMETER }

      it { expect( its :length ).to eq 1 }
      it { expect( its :first, :location ).not_to be_nil }
    end


    context 'who are not close enough' do
      let(:radius) { 0 }

      it { expect( its :length ).to eq 2 }
      it { expect( its :first, :location ).not_to be_nil }
      it { expect( its :second, :location ).not_to be_nil }
    end
  end
end
