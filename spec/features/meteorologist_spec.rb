require "rails_helper"
Rails.application.load_tasks

describe "rails api:stubbed" do

  it "displays the latitude and longitude of street address", points: 0 do

    address = "Chicago, IL"
    expect($stdout).to receive(:puts).with("Enter your street address:")
    allow(STDIN).to receive(:gets).and_return(address )
    expect($stdout).to receive(:puts).with("Okay, getting the weather forecast for #{address}...")
    expect($stdout).to receive(:puts).with(/Your latitude is -*\d+.\d+/)
    expect($stdout).to receive(:puts).with(/Your longitude is -*\d+.\d+/)

    expect($stdout).to receive(:puts).with(/Current temperature: -*\d+.\d+/)
    expect($stdout).to receive(:puts).with(/Current summary: \w+\s*/)
    expect($stdout).to receive(:puts).with(/For the next few minutes: \w+\s*/)
    expect($stdout).to receive(:puts).with(/For the next few hours: \w+\s*/)
    expect($stdout).to receive(:puts).with(/For the next few days: \w+\s*,*\s*°*/)

    maps_url = /.*maps.googleapis.com\/maps\/api\/geocode\/json.address=\d*\D*\d*&key=(.*)/
    stub_request(:any, maps_url).to_return(body: File.new('spec/maps_response_body.txt'), status: 200)

    new_forecasts_url = /.*api.darksky.net\/forecast\/.*\/#{Regexp.new('38.8977332')},#{Regexp.new('-77.0365305')}/
    stub_request(:any, new_forecasts_url).to_return(body: File.new('spec/forecasts_response_body.txt'), status: 200)
    Rake::Task["api:stubbed"].invoke

  end



end
