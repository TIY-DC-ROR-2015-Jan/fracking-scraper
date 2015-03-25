module V1
  class WeatherController < ApiController
    def my_location
      @weather = Weather.at current_user.location
    end
  end
end
