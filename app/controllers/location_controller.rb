class LocationController < ApplicationController
  def root
    if(params[:zip_code])
      puts "============================================================================"
      puts "Root Params are #{params}"
      puts "============================================================================"
      redirect_to "/location/#{params[:zip_code]}"
    end
  end


  def show
    puts "============================================================================"
    puts "Show Params are #{params}"
    puts "============================================================================"
    if(verify_format(params[:zip_code]))
      @zip_code = params[:zip_code]
      @locations = Location.last_days(@zip_code)

      if(@locations.length < 10)
        raw_json = query_locations(@zip_code)
        unless(raw_json["response_code"] && raw_json["response_code"].to_i > 200)
          @locations = Location.save_locations(raw_json, @zip_code)
        else
          @zip_code = nil
          @locations = []
          flash[:errors] = ["Zip code #{params[:zip_code]} does not appear in our records!"]
        end
      end

    else
      @zip_code = nil
      @locations = []
      flash[:errors] = ["Zip code should be in the format 12345"]
    end

    if(@locations.empty?)
      redirect_to root_url
    end
  end

  private
  def query_locations(zip_code, limit=10 )
    # start_date = dates[0]
    # end_date = dates[1]
    start_date ||= Location.isoParse((limit+1).days.ago)
    end_date ||= Location.isoParse(Time.now)

    zip_s = "postal_code_eq=#{zip_code}"
    country_s = "country_eq=US"
    time_btw = "timestamp_between=#{start_date},#{end_date}"
    limit_s = "limit=#{limit}"
    field_s = "fields=precip,timestamp"

    query = [zip_s, country_s, time_btw, limit_s, field_s].join("&")

    url = URI.parse(
      "https://api.weathersource.com/v1/#{WEATHER_SOURCE_API_KEY}/history_by_postal_code.json?#{query}"
    )
    puts "============================================================================"
    puts "API KEY IS #{WEATHER_SOURCE_API_KEY}"
    puts "QUERY IS #{query}"
    puts "============================================================================"
    req = Net::HTTP.new(url.host,url.port)
    req.use_ssl = true
    res = req.get(url.request_uri)
    res.body
  end

  def verify_format(zip_code)
    return (zip_code.length == 5 && zip_code.match(/\d{5}/).to_s == zip_code)
  end


end
