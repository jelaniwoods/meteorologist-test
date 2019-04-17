namespace :api do
  desc "make a bogus api call and rspec it"
  task stubbed: :environment do

    puts "Enter your street address:"
    street_address = $stdin.gets.chomp
    # street_address = "Merchandise Mart, Chicago"

    puts "Okay, getting the weather forecast for " + street_address + "..."


    gmaps_api_endpoint = "https://maps.googleapis.com/maps/api/geocode/json?address=" + street_address + "&key=" + ENV.fetch("GMAPS_KEY")

    require("open-uri")

    raw_gmaps_data = open(gmaps_api_endpoint).read

    parsed_gmaps_data = JSON.parse(raw_gmaps_data)

    results = parsed_gmaps_data.fetch("results")
    first_result = results.at(0)
    geometry = first_result.fetch("geometry")
    location = geometry.fetch("location")

    latitude = location.fetch("lat")
    longitude = location.fetch("lng")

    puts "Your latitude is " + latitude.to_s
    puts "Your longitude is " + longitude.to_s

    forecast_api_endpoint = "https://api.darksky.net/forecast/" + ENV.fetch("DARK_SKY_KEY") + "/" + latitude.to_s + "," + longitude.to_s

    raw_forecast_data = open(forecast_api_endpoint).read
    parsed_forecast_data = JSON.parse(raw_forecast_data)

    current_temp = parsed_forecast_data.fetch("currently").fetch("temperature")

    puts "Current temperature: " + current_temp.to_s

    current_summary = parsed_forecast_data.fetch("currently").fetch("summary")

    puts "Current summary: " + current_summary

    minutely_summary = parsed_forecast_data.fetch("minutely").fetch("summary")

    puts "For the next few minutes: " + minutely_summary

    hourly_summary = parsed_forecast_data.fetch("hourly").fetch("summary")

    puts "For the next few hours: " + hourly_summary

    daily_summary = parsed_forecast_data.fetch("daily").fetch("summary")

    puts "For the next few days: " + daily_summary
  end

end
