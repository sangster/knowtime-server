require 'uuidtools'

module UUIDTools
  class UUID
    def as_json options
      to_s
    end
  end
end