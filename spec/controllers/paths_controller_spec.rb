require 'spec_helper'

describe PathsController do
  render_views

  before { create :calendar }
  before { @trips = [create(:trip), create(:trip)]}
  before(:each) { request.env["HTTP_ACCEPT"] = 'application/json' }

  let(:json) { JSON.parse response.body }
  let(:route_uuid) { create(:route).uuid.to_s }
  let(:params_with_bad_date)  {{ year: 1990, month: 1, day: 1, route_uuid: route_uuid }}
  let(:params_with_good_date) {{ year: 2014, month: 1, day: 1, route_uuid: route_uuid }}


  describe '#show' do
    subject { create :path_with_points }
    before(:each) { get :show, path_uuid: path_uuid }

    context 'with a bad UUID' do
      let(:path_uuid) { 'bad-uuid' }
      it { expect( response ).to be_not_found }
    end

    context 'with a good UUID' do
      let(:path_uuid) { its :uuid, :to_s }

      it { expect( assigns :path ).to eq subject }
      it { expect( response ).to be_ok }
      it { expect( json['pathId'] ).to eq( its :uuid, :to_s ) }
      it 'have pathPoints' do
        expected = subject.path_points.collect {|point| {'lat' => point.lat, 'lng' => point.lng}}
        expect( json['pathPoints'] ).to match_array expected
      end
    end
  end


  describe '#index_for_route_and_date' do
    context 'when no paths exist' do
      context 'with a bad date' do
        before { get :index_for_route_and_date, params_with_bad_date }

        it { expect( response ).to be_not_found }
        it { expect( json['error'] ).to match /no calendars found/ }
      end

      context 'with a good date' do
        before(:each) { get :index_for_route_and_date, params_with_good_date }

        it { expect( json ).to be_empty }


        context 'with a bad route uuid' do
          let(:route_uuid) { 'bad-route-uuid' }

          it { expect( response ).to be_not_found }
          it { expect( json['error']).to match /no route found/ }
        end
      end
    end


    context 'when paths exist' do
      subject {[ create(:path_with_points), create(:path_with_points) ]}

      it 'should return 404 for bad date' do
        params = {year: 1990, month: 1, day: 1, route_uuid: @trips.first.route.uuid.to_s}
        get :index_for_route_and_date, params
        expect( response ).to be_not_found
      end

      it 'should return message for bad date' do
        params = {year: 1990, month: 1, day: 1, route_uuid: @trips.first.route.uuid.to_s}
        get :index_for_route_and_date, params
        expect( json['error'] ).to match /no calendars found/
      end

      it 'should return 404 for bad route uuid' do
        params = {year: 2014, month: 1, day: 1, route_uuid: 'bad-route'}
        get :index_for_route_and_date, params
        expect( response ).to be_not_found
      end

      it 'should return message for bad route uuid' do
        params = {year: 2014, month: 1, day: 1, route_uuid: 'bad-route'}
        get :index_for_route_and_date, params
        expect( json['error'] ).to match /no route found/
      end

      pending 'should return paths' do
        # params = {year: 2014, month: 1, day: 1, route_uuid: @trips.first.route.uuid.to_s}
        # get :index_for_route_and_date, params
        # expect(json.length).to eq(2)
      end
    end    
  end
end
