module Utilities
  module_function

  def production_deployment?
    ENV['ENV_NAME']&.downcase == 'production'
  end
end
