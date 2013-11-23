class UsersController < ApplicationController
  def show
    user = User.get params[:user_uuid]
    @user_locations = user.user_locations
  end


  def create
    short_name = params[:short_name]
    raise "short_name does not exist: #{short_name}" unless Route.short_name_exists? short_name

    @user = User.new short_name: short_name, uuid: UUIDTools::UUID.random_create.raw
    if @user.save
      redirect_to "/user/#{@user.uuid_str}", status: :created
      response_body = ''
    else
      raise 'could not save user'
    end
  end


  def create_location
    user = User.get params[:user_uuid]
    user.user_locations.create lat: params[:lat], lng: params[:lng]
    render nothing: true
  end
end
