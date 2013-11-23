require 'net/http'
require 'open-uri'
require 'zip/filesystem'
require 'csv'


class DataPull < ActiveRecord::Base
  BULK_INSERT_SIZE = 1024

  # TODO replace with cron job
  def self.check_remote_zip
    Rails.cache.fetch('check_remote_zip', expires_in: 5.minutes) { uncached_check_remote_zip }
  end

  def self.uncached_check_remote_zip
    url = URI METRO_TRANSIT['zip_url']

    logger.info "Checking remote zip #{url} for updates"
    server_etag = fetch_remote_etag(url)[1..-2]

    pull = DataPull.last

    if pull.nil? or pull.etag != server_etag
      logger.info 'Previous data pull does not exist or is out of date'

      DataPull.download_zip url do |zip|
        bulk_insert_rows zip, 'stops.txt', Stop
        bulk_insert_rows zip, 'shapes.txt', PathPoint
        bulk_insert_rows zip, 'routes.txt', Route
        bulk_insert_rows zip, 'calendar.txt', Calendar
        bulk_insert_rows zip, 'calendar_dates.txt', CalendarException
        bulk_insert_rows zip, 'trips.txt', Trip
        bulk_insert_rows zip, 'stop_times.txt', StopTime

        DataPull.create url: METRO_TRANSIT['zip_url'], etag: server_etag
        logger.info 'Finished reading CSV files'
      end
    else
      logger.info "Current database is up to date. Latest etag: #{pull.etag}"
    end

    true # for the cache
  end


  def self.bulk_insert_rows(zip, zip_filename, model_class)
    logger.info "Deleting all rows from #{model_class}"
    model_class.delete_all

    total = 0
    models = []
    zip.file.open(zip_filename) do |f|
      CSV.new(f, :headers => true, :header_converters => :symbol).each do |row|
        models << model_class.new_from_csv(row)

        if models.length == BULK_INSERT_SIZE
          transaction { models.each &:save }
          total = total + models.length
          models.clear
          logger.info "Inserted #{BULK_INSERT_SIZE} objects for #{model_class} (total: #{total})"
        end
      end
    end

    unless models.empty? # whatever is left
      transaction { models.each &:save }
      logger.info "Inserted #{models.length} objects for #{model_class} (total: #{total + models.length})"
    end
  end


  def self.fetch_remote_etag url
    Net::HTTP.start(url.host) { |http| http.request_head(url.path)['etag'] }
  end


  def self.download_zip(url, &block)
    file = Tempfile.new 'metro_transit'
    file.binmode
    file << open(url).read
    Zip::File.open(file, &block)
    file.delete
  end
end