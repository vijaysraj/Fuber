class RidesController < ApplicationController

  before_filter :check_availability, :only => :start_ride

  def start_ride
    @ride = Ride.new(start_params)
    if @cabs.present?
      assign_cab
      @ride.cab = @nearest_cab
      @nearest_cab.update_attributes(:availability => false)
      @ride.status = 'accepted'
    else
      @ride.status = 'rejected'
    end
      @ride.save
      @message = @ride.cab.present? ? 'Your request has been accepted' : 'Sorry, there are no cabs available at this time'
      render json: {ride: @ride, message: @message, status_code: 201}
  end

  def stop_ride
    @ride = Ride.find(params[:id])
    @cab = @ride.cab
    unless @ride.status == 'completed'
      @ride.update_attributes(stop_params)
      @cab.availability = true
      @cab.latitude = @ride.ending_latitude
      @cab.longitude = @ride.ending_longitude
      @cab.save
      calculate_fare
    end
    render json: {ride: @ride, cab: @cab, message: 'Your ride has ended. The cost of the ride is ' + @ride.cost.to_s + ' dogecoin'}
  end

  def calculate_fare
    @distance_travelled = (@cab.distance_from([@ride.starting_latitude, @ride.starting_longitude]) * 1.60934).round(2)
    @time_travelled = ((@ride.updated_at - @ride.created_at)/60).round(2)
    @ride.cost = (2 * @distance_travelled) + (@time_travelled)
    @ride.cost += 5 if @cab.color == 'pink'
    @ride.distance_travelled = @distance_travelled
    @ride.status = 'completed'
    @ride.save
  end

  private

  def start_params
    params.require(:ride).permit(:starting_latitude, :starting_longitude, :color)
  end

  def stop_params
    params.require(:ride).permit(:ending_latitude, :ending_longitude)
  end

  def check_availability
    @requested_color = params[:ride][:color].present? ? params[:ride][:color] : 'white'
    @cabs = Cab.where('availability = ? AND color = ?', true, @requested_color)
  end

  def assign_cab
    @nearest_cab_distance = nil
    @nearest_cab = nil
    @cabs.each do |cab|
      distance = cab.distance_from([@ride.starting_latitude, @ride.starting_longitude])
      if @nearest_cab_distance.nil? || (!@nearest_cab_distance.nil? && distance < @nearest_cab_distance)
        @nearest_cab_distance = distance
        @nearest_cab = cab
      end
    end
  end

end
