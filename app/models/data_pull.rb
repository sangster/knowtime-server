require 'net/http'
require 'open-uri'
require 'zip/filesystem'
require 'csv'


class DataPull
  include Mongoid::Document

  field :url, type: String
  field :etag, type: String


  BULK_INSERT_SIZE = 1024

  # TODO replace with cron job
  def self.remote_zip_new?
    url = URI METRO_TRANSIT['zip_url']

    logger.info "Checking remote zip #{url} for updates"
    server_etag = fetch_remote_etag(url)[1..-2]

    pull = DataPull.last
    pull.nil? or pull.etag != server_etag
  end

  def self.update_from_remote_zip
    url = URI METRO_TRANSIT['zip_url']
    logger.info "Updating data from #{url}"

    DataPull.download_zip url do |zip|
      bulk_insert_rows zip, 'stops.txt', Stop
      bulk_insert_rows zip, 'shapes.txt', Path
      bulk_insert_rows zip, 'routes.txt', Route
      bulk_insert_rows zip, 'calendar.txt', Calendar
      bulk_insert_rows zip, 'calendar_dates.txt', CalendarException
      bulk_insert_rows zip, 'trips.txt', Trip
      bulk_insert_rows zip, 'stop_times.txt', StopTime

      DataPull.create! url: METRO_TRANSIT['zip_url'], etag: fetch_remote_etag(url)[1..-2]
      logger.info 'Finished reading CSV files'
    end
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
          model_class.create! models unless (model_class.skip_bulk_insert? rescue false)
          total = total + models.length
          models.clear
          logger.info "Inserted #{BULK_INSERT_SIZE} objects for #{model_class} (total: #{total})"
        end
      end
    end

    unless models.empty? # whatever is left
      model_class.create! models unless (model_class.skip_final_bulk_insert? rescue false)
      logger.info "Inserted #{models.length} objects for #{model_class} (total: #{total + models.length})"
    end
  end

  def self.fetch_remote_etag(url)
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
