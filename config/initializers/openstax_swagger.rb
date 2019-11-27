OpenStax::Swagger.configure do |config|
  config.json_proc = -> (api_major_version) {
    Swagger::Blocks.build_root_json(
      "Api::V#{api_major_version}::SwaggerController::SWAGGERED_CLASSES".constantize
    )
  }
  config.client_language_configs = {
    ruby: lambda do |version|
      {
        gemName: 'highlights-ruby',
        gemHomepage: 'https://github.com/openstax/highlights-api/clients/ruby',
        gemRequiredRubyVersion: '>= 2.4',
        moduleName: "OpenStax::Highlights",
        gemVersion: version,
      }
    end
  }
end
