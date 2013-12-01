class UsersController < ApplicationController
  def show
    user = User.get params[:user_uuid]

    if user.nil?
      render_error :not_found, "no user for UUID: #{params[:user_uuid]}"
    else
      @user_locations = user.user_locations
    end
  end


  def create
    short_name = params[:short_name]
    raise "short_name does not exist: #{short_name}" unless Route.short_name_exists? short_name

    uuid = BSON::Binary.new UUIDTools::UUID.random_create.raw, :uuid
    @user = User.new short_name: short_name, uuid: uuid

    if @user.save
      redirect_to "/alpha_1/user/#{@user.uuid_str}", status: :created
      response_body = ''
    else
      raise 'could not save user'
    end
  end


  def create_location
    user = User.get params[:user_uuid]

    if user.nil?
      render_error :not_found, "no user for UUID: #{params[:user_uuid]}"
    else
      user.user_locations.create! lat: params[:lat], lng: params[:lng]
      render nothing: true
    end
  end

  def index
    @bus_riders_map = User.recent_users_bus_map 1.hour
  end
end
