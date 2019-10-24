module Api::V0::SwaggerResponses
  module AuthenticationErrorId
    def self.extended(base)
      base.response 401 do
        key :description, 'Not authorized.  Happens when API ID or origin are not set.'
      end
    end
  end

  module AuthenticationErrorToken
    def self.extended(base)
      base.response 401 do
        key :description, 'Not authorized.  Happens when API token is not set.'
      end
    end
  end

  module ForbiddenErrorId
    def self.extended(base)
      base.response 403 do
        key :description, 'Forbidden.  Happens when API ID or origin are not correct.'
      end
    end
  end

  module ForbiddenErrorToken
    def self.extended(base)
      base.response 403 do
        key :description, 'Forbidden.  Happens when API token is not correct.'
      end
    end
  end

  module NotFoundError
    def self.extended(base)
      base.response 404 do
        key :description, 'Not found'
      end
    end
  end

  module UnprocessableEntityError
    def self.extended(base)
      base.response 422 do
        key :description, 'Could not process request'
        schema do
          key :'$ref', :Error
        end
      end
    end
  end

  module ServerError
    def self.extended(base)
      base.response 500 do
        key :description, 'Server error.'
        schema do
          key :'$ref', :Error
        end
      end
    end
  end
end
