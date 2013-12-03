require 'spec_helper'

describe PathsController do
  render_views

  before(:each) { request.env["HTTP_ACCEPT"] = 'application/json' }

  describe '#show' do
    subject { create :path_with_points }

    it 'should return 404 for bad UUID' do
      get :show, path_uuid: 'bad-uuid'
      expect(response).to be_not_found      
    end

    it 'assigns @path' do
      get :show, path_uuid: subject.uuid.to_s
      expect(assigns(:path)).to eq(subject)
    end

    it 'should return 200 for found' do
      get :show, path_uuid: subject.uuid.to_s
      expect(response).to be_ok
    end

    it 'has pathId' do
      get :show, path_uuid: subject.uuid.to_s
      json = JSON.parse response.body

      expect(json['pathId']).to eql(subject.uuid.to_s)
    end

    it 'has pathPoints' do
      get :show, path_uuid: subject.uuid.to_s
      json = JSON.parse response.body

      expected = subject.path_points.collect {|point| {'lat' => point.lat, 'lng' => point.lng}}
      expect(json['pathPoints']).to match_array(expected)
    end
  end

  describe '#index_for_route_and_date' do
    before(:each) do
      @route = create :route
      @calendar = create :calendar
    end

    context 'when no paths exist' do
      it 'should return 404 for bad date' do
        params = {year: 1990, month: 1, day: 1, route_uuid: @route.uuid.to_s}
        get :index_for_route_and_date, params
        expect(response).to be_not_found
      end

      it 'should return message for bad date' do
        params = {year: 1990, month: 1, day: 1, route_uuid: @route.uuid.to_s}
        get :index_for_route_and_date, params
        expect(JSON.parse(response.body)['error']).to match(/no calendars found/)
      end

      it 'should return 404 for bad route uuid' do
        params = {year: 2014, month: 1, day: 1, route_uuid: 'bad-route'}
        get :index_for_route_and_date, params
        expect(response).to be_not_found
      end

      it 'should return message for bad route uuid' do
        params = {year: 2014, month: 1, day: 1, route_uuid: 'bad-route'}
        get :index_for_route_and_date, params
        expect(JSON.parse(response.body)['error']).to match(/no route found/)
      end

      it 'should return an empty list' do
        params = {year: 2014, month: 1, day: 1, route_uuid: @route.uuid.to_s}
        get :index_for_route_and_date, params
        expect(JSON.parse response.body).to be_empty
      end
    end

    context 'when paths exist' do
      subject do
        [create(:path_with_points), create(:path_with_points)]
      end
      it 'should return 404 for bad date' do
        params = {year: 1990, month: 1, day: 1, route_uuid: @route.uuid.to_s}
        get :index_for_route_and_date, params
        expect(response).to be_not_found
      end

      it 'should return message for bad date' do
        params = {year: 1990, month: 1, day: 1, route_uuid: @route.uuid.to_s}
        get :index_for_route_and_date, params
        expect(JSON.parse(response.body)['error']).to match(/no calendars found/)
      end

      it 'should return 404 for bad route uuid' do
        params = {year: 2014, month: 1, day: 1, route_uuid: 'bad-route'}
        get :index_for_route_and_date, params
        expect(response).to be_not_found
      end

      it 'should return message for bad route uuid' do
        params = {year: 2014, month: 1, day: 1, route_uuid: 'bad-route'}
        get :index_for_route_and_date, params
        expect(JSON.parse(response.body)['error']).to match(/no route found/)
      end

      it 'should return paths' do
        params = {year: 2014, month: 1, day: 1, route_uuid: @route.uuid.to_s}
        get :index_for_route_and_date, params
        json = JSON.parse(response.body)
        expect(json.length).to be(2)
      end
    end    
  end
end
