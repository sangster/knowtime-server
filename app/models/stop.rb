class Stop < ActiveRecord::Base
  TO_LOWER = %w(Bvld Dr Ave Rd St To Pk Terr Ct Pkwy Hwy Lane Way Entrance Entr.)


  def self.new_from_csv row
    Stop.new stop_number: row[:stop_id], name: format_short_name(row[:stop_name]), lat: row[:stop_lat], lng: row[:stop_lon]
  end


  def self.format_short_name str
    str.strip!
    TO_LOWER.each { |lower| str.gsub! /\b#{lower}\b/, lower.downcase }
    str[0] = str[0].upcase
    str
  end


  def self.get_id stop_number
    Rails.cache.fetch("stop_id_#{stop_number}", eternal: true) do
      Stop.find_by_stop_number(stop_number, select: 'id').id
    end
  end


  def route_short_names
    Route.joins(:trips, :stop_times).where('stop_times.stop_id = ?', id).uniq.pluck :short_name
  end


  def trips
    Trip.joins(:stop_times).where stop: id
  end
end
