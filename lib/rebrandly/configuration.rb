module Rebrandly
  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def api_key
      configuration.api_key
    end

    def workspace
      configuration.workspace
    end

    def configure
      yield(configuration)
    end

    private

    class Configuration
      attr_accessor :api_key, :workspace
    end
  end
end
