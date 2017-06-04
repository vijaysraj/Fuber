class CabsController < ApplicationController

  def index
    @available_cabs = Cab.where('availability = ?', true).order('id ASC')
  end

  def create
    @cab = Cab.new(cab_params)
    if @cab.save
      render json: {cab: @cab, message: 'Cab created successfully', succes: true, status_code: 201}
    else
      render json: {errors: @cab.errors ,message: 'Creation of cab failed'}
    end
  end


  private

  def cab_params
    params.require(:cab).permit(:latitude, :longitude, :color)
  end

end
