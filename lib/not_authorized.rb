class NotAuthorized
  class Error < StandardError; end

  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue NotAuthorized::Error
      ApplicationController.action(:error_401).call(env)
    end
  end
end
