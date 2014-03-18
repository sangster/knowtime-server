class V1::UsersController < V1::ApplicationController
  def show
    user = User.find_by uuid: params[:uuid]

    if user.nil?
      render_error :not_found, "no user for UUID: #{params[:uuid]}"
    else
      @user_locations = user.user_locations
    end
  end

  def create
    short_name = params[:short_name]
    if Route.where( route_short_name: short_name ).count == 0
      raise "short_name does not exist: #{short_name}"
    end

    @user = User.create!(route_short_name: short_name).tap &:reload
    redirect_to "/alpha_1/user/#{@user.uuid}", status: :created
  end

  def create_location
    user = User.find_by uuid: params[:uuid]

    user.user_locations.create! lat: params[:lat], lon: params[:lng]
    render nothing: true
  end

  def index
    @bus_riders_map = User.recent_users_bus_map 1.hour
  end
end
