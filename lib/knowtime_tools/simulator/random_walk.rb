module Knowtime
  module Simulator
    class RandomWalk
      MIN_SECONDS = 3
      STEP_LENGTH = 0.001
      STEPS_PER_DIRECTION = 10

      #@param user [Simulator::User] the user to walk around
      #@param delay [Integer] the seconds to wait between sending locations
      def initialize(user, delay)
        @user, @delay = user, delay
        @stopped = false

        if delay < MIN_SECONDS
          raise "Delay must be at least #{MIN_SECONDS} seconds."
        end
      end

      def start
        Thread.new do
          location_enum.each do |location|
            lat = location[:lat]
            lng = location[:lng]
            puts "#{@user.id} << (#{lat} , #{lng})"
            @user.post_location lat, lng
            sleep @delay
          end
        end
      end

      def stop
        @stopped = true
      end

      private

      def location_enum
        loc = {lat: 0.0, lng: 0.0}
        offset = {lat: 0.0, lng: 0.0}
        steps_in_direction = 0

        Enumerator.new do |yielder|
          until @stopped do
            if steps_in_direction == STEPS_PER_DIRECTION
              steps_in_direction = 0
              randomize_direction offset
            end
            steps_in_direction += 1
            loc[:lat] += offset[:lat]
            loc[:lng] += offset[:lng]
            yielder.yield constrain loc
          end
        end
      end

      def randomize_direction(offset)
        offset[:lat] = (-rand + rand) * STEP_LENGTH
        offset[:lng] = (-rand + rand) * STEP_LENGTH
      end

      def constrain(loc)
        loc[:lat] = [-90.0, [loc[:lat], 90.0].min].max
        loc[:lng] = [-180.0, [loc[:lng], 180.0].min].max
        loc
      end
    end
  end
end