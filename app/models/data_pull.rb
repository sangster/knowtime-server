require 'net/http'
require 'gtfs'


class DataPull
  include Mongoid::Document

  field :url, type: String
  field :etag, type: String


  BULK_INSERT_SIZE = 1024

  class << self

    def update_from_remote_zip
      url = METRO_TRANSIT['zip_url']
      logger.info "Updating data from #{url}"

      source = GTFS::Source.build url

      source.each_stop &from_gtfs( Stop )
      bulk_insert_rows source.shapes, Path
      source.each_route &from_gtfs( Route )
      source.each_calendar &from_gtfs( Calendar )
      source.each_calendar_date &from_gtfs( CalendarException )
      source.each_trip &from_gtfs( Trip )
      bulk_insert_rows source.stop_times, StopTime

      TripGroup.create_groups

      DataPull.create! url: METRO_TRANSIT['zip_url'], etag: fetch_remote_etag(url)[1..-2]
      logger.info 'Finished reading CSV files'
    end

    def bulk_insert_rows(rows, model_class)
      logger.info "Deleting all rows from #{model_class}"
      model_class.delete_all

      total = 0
      models = []
      rows.each do |row|
        models << model_class.new_from_csv(row)

        if models.length == BULK_INSERT_SIZE
          model_class.create! models unless (model_class.skip_bulk_insert? rescue false)
          total = total + models.length
          models.clear
          logger.info "Inserted #{BULK_INSERT_SIZE} objects for #{model_class} (total: #{total})"
        end
      end

      unless models.empty? # whatever is left
        model_class.create! models unless (model_class.skip_final_bulk_insert? rescue false)
        logger.info "Inserted #{models.length} objects for #{model_class} (total: #{total + models.length})"
      end
    end

    # TODO replace with cron job
    def remote_zip_new?
      url = METRO_TRANSIT['zip_url']

      logger.info "Checking remote zip #{url} for updates"
      server_etag = fetch_remote_etag(url)[1..-2]

      pull = DataPull.last
      pull.nil? or pull.etag != server_etag
      true
    end

    private

    def from_gtfs(model)
      model.delete_all
      method = model.method :from_gtfs
      Proc.new do |row|
        obj = method.call row
        # logger.info "Create #{model.name}: '#{obj.id}'"
      end
    end

    def fetch_remote_etag(url_str)
      url = URI url_str
      Net::HTTP.start(url.host) { |http| http.request_head(url.path)['etag'] }
    end
  end
end
