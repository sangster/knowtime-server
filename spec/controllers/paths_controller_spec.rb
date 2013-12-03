require 'spec_helper'

describe PathsController do
  describe '#show' do
    subject { create :path_with_points }

    it 'assigns @path' do
      get :show, path_uuid: subject.uuid.to_s, format: :json
      expect(assigns(:path)).to eq(subject)
    end

    it 'should have status 200' do
      get :show, path_uuid: subject.uuid.to_s, format: :json
      expect(response.status).to eq(200)
    end

    it 'has pathId' do
      get :show, path_uuid: subject.uuid.to_s, format: :json      
      json = JSON.parse response.body

      expect{json['pathId']}.to eql(subject.uuid.to_s)
    end
  end
end
