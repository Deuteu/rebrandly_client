module Rebrandly
  class Error < StandardError
    def new(message)
      super("Rebrandly >> #{message}")
    end
  end

  class MissingApiKey < Error
    def new
      super('Missing API key')
    end
  end

  class RateLimitExceeded < Error
    def new(message)
      super("RateLimit >> #{message}")
    end
  end

  class UsageLimitExceeded < Error
    def new(source)
      super("Usage limit reach on #{source}")
    end
  end
end
