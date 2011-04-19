module PowerNap
  class << self
    def resources
      @resources ||= []
    end

    def register(resource)
      resources << resource
    end
  end
end

require_relative "powernap/resource"
