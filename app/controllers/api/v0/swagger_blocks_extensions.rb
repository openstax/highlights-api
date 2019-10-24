module Api::V0::SwaggerBlocksExtensions

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def add_properties(*schema_names, &block)
      schema_names.each do |schema_name|
        swagger_schema schema_name do
          instance_eval(&block)
        end
      end
    end
  end

end
