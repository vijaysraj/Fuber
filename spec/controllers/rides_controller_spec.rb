require 'rails_helper'

RSpec.describe RidesController, type: :controller do

  let(:cab1){FactoryGirl.create(:cab, address: "17/1, Paduvaralli, Vinayakanagara, Mysuru, Karnata...", latitude: 12.3187036507578, longitude: 76.6288661956787, color: "white", availability: true)}
  let(:cab2){FactoryGirl.create(:cab, address: "Vijaya Nagar 4th Stage, CFTRI Campus, Yadavagiri, ...", latitude: 12.3174458299272, longitude: 76.637020111084, color: "white", availability: true)}
  let(:cab3){FactoryGirl.create(:cab, address: "Nobel Laureate Ave, Manasa Gangothiri, Mysuru, Kar...", latitude: 12.312666055787, longitude: 76.6237163543701, color: "white", availability: true)}
  let(:cab4){FactoryGirl.create(:cab, address: "2029, Dhanavantri Rd, Devaraja Mohalla, Shivarampe...", latitude: 12.312666055787, longitude: 76.6486930847168, color: "pink", availability: true)}
  let(:cab5){FactoryGirl.create(:cab, address: "39/2, Gokulam Main Rd, Vani Vilas Mohalla, Mysuru,...", latitude: 12.3269212650991, longitude: 76.6269779205322, color: "pink", availability: true)}

  let(:cab6){FactoryGirl.create(:cab, address: "17/1, Paduvaralli, Vinayakanagara, Mysuru, Karnata...", latitude: 12.3187036507578, longitude: 76.6288661956787, color: "white", availability: false)}
  let(:cab7){FactoryGirl.create(:cab, address: "Vijaya Nagar 4th Stage, CFTRI Campus, Yadavagiri, ...", latitude: 12.3174458299272, longitude: 76.637020111084, color: "white", availability: false)}
  let(:cab8){FactoryGirl.create(:cab, address: "Nobel Laureate Ave, Manasa Gangothiri, Mysuru, Kar...", latitude: 12.312666055787, longitude: 76.6237163543701, color: "white", availability: false)}
  
  let(:ride1){FactoryGirl.create(:ride, starting_latitude: 12.3187036507578, starting_longitude: 76.6288661956787, color: "white", cab_id: cab1.id, status: "accepted")}

  describe 'start rides'
  it "should assign the nearest cab to the customer based on the location if the cabs are available" do
    cab1
    cab2
    cab3
    params = { 
      "ride" =>  {
        "starting_latitude" => 12.320857654924694,
        "starting_longitude" => 76.6276216506958,
        "color" => "white"
      }
    }
    post :start_ride, params
    expect(assigns(:ride).cab).to eq(cab1)
    expect(assigns(:ride).cab.availability).to eq(false)
    expect(assigns(:ride).status).to eq('accepted')
  end

  it "should assign the nearest cab with color pink to the customer based on there selection of pink color cabs" do
    cab4
    cab5
    params = { 
      "ride" =>  {
        "starting_latitude" => 12.320857654924694,
        "starting_longitude" => 76.6276216506958,
        "color" => "pink"
      }
    }
    post :start_ride, params
    expect(assigns(:ride).cab).to eq(cab5)
    expect(assigns(:ride).cab.availability).to eq(false)
    expect(assigns(:ride).status).to eq('accepted')
  end

  it "should reject the request if there are no cabs available" do
    cab6
    cab7
    cab8
    params = { 
      "ride" =>  {
        "starting_latitude" => 12.320857654924694,
        "starting_longitude" => 76.6276216506958,
        "color" => "white"
      }
    }
    post :start_ride, params
    expect(assigns(:ride).status).to eq('rejected')
  end

  describe "stop ride"
  it "should update latitude and longitude of the cab and should be available for the next ride once the customer ends the ride" do
    cab1
    ride1
    params = { 
      'ride' => {
        "ending_latitude"=> 12.351153341832683,
        "ending_longitude"=> 76.61278367042542
      }, 'id' => ride1.id
    }
    put :stop_ride, params
    expect(assigns(:ride).status).to eq('completed')
    expect(assigns(:cab).latitude).to eq(12.351153341832683)
    expect(assigns(:cab).longitude).to eq(76.61278367042542)
    expect(assigns(:cab).availability).to eq(true)
  end

  it "should calculate the fare once the customer ends the ride" do
    cab1
    ride1
    params = { 
      'ride' => {
        "ending_latitude"=> 12.351153341832683,
        "ending_longitude"=> 76.61278367042542
      }, 'id' => ride1.id
    }
    put :stop_ride, params
    expect(assigns(:ride).status).to eq('completed')
    expect(assigns(:ride).distance_travelled).to eq(4)
    expect(assigns(:ride).cost).to eq(8)
  end

end
