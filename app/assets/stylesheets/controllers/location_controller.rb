class LocationsController < ApplicationController
  def root

  end



  def show

    @locations = Location.last_days(params[:zip_code])
    if(@locations.empty?)
      redirect_to root_url
      flash[:errors] = ["Zip code #{params[:zip_code]} does not appear in our records!"]
    end

  end

  private
  def location_params
    params.require(:location).permit(:zip_code)
  end

end
