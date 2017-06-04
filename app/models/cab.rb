class Cab < ActiveRecord::Base

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode, :if => :latitude_changed?

  has_many :rides

end
