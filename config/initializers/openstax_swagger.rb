OpenStax::Swagger.configure do |config|
  config.json_proc = -> (api_major_version) {
    Swagger::Blocks.build_root_json(
      "Api::V#{api_major_version}::SwaggerController::SWAGGERED_CLASSES".constantize
    )
  }
end
