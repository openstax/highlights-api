=begin
#OpenStax Highlights API

#The highlights API for OpenStax.  Requests to this API should include `application/json` in the `Accept` header.  The desired API version is specified in the request URL, e.g. `[domain]/highlights/api/v0/highlights`. While the API does support a default version, that version will change over time and therefore should not be used in production code! 

OpenAPI spec version: 0.1.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.6

=end

require 'date'

module Api::V0::Bindings
  class GetHighlightsParameters
    # Limits results to those highlights made in sources of this type.
    attr_accessor :source_type

    # Limits results to the source document container in which the highlight was made.  For openstax_page source_types, this is a versionless book UUID. If this is not specified, results across scopes will be returned, meaning the order of the results will not be meaningful.
    attr_accessor :scope_id

    # One or more source IDs; query results will contain highlights ordered by the order of these source IDs and ordered within each source.  If parameter is an empty array, no results will be returned.  If the parameter is not provided, all highlights under the scope will be returned.
    attr_accessor :source_ids

    # Limits results to this highlight color.
    attr_accessor :color

    # The page number of paginated results, one-indexed.
    attr_accessor :page

    # The number of highlights per page for paginated results.
    attr_accessor :per_page

    class EnumAttributeValidator
      attr_reader :datatype
      attr_reader :allowable_values

      def initialize(datatype, allowable_values)
        @allowable_values = allowable_values.map do |value|
          case datatype.to_s
          when /Integer/i
            value.to_i
          when /Float/i
            value.to_f
          else
            value
          end
        end
      end

      def valid?(value)
        !value || allowable_values.include?(value)
      end
    end

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'source_type' => :'source_type',
        :'scope_id' => :'scope_id',
        :'source_ids' => :'source_ids',
        :'color' => :'color',
        :'page' => :'page',
        :'per_page' => :'per_page'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'source_type' => :'String',
        :'scope_id' => :'String',
        :'source_ids' => :'Array<String>',
        :'color' => :'String',
        :'page' => :'Integer',
        :'per_page' => :'Integer'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'source_type')
        self.source_type = attributes[:'source_type']
      end

      if attributes.has_key?(:'scope_id')
        self.scope_id = attributes[:'scope_id']
      end

      if attributes.has_key?(:'source_ids')
        if (value = attributes[:'source_ids']).is_a?(Array)
          self.source_ids = value
        end
      end

      if attributes.has_key?(:'color')
        self.color = attributes[:'color']
      end

      if attributes.has_key?(:'page')
        self.page = attributes[:'page']
      end

      if attributes.has_key?(:'per_page')
        self.per_page = attributes[:'per_page']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @source_type.nil?
        invalid_properties.push('invalid value for "source_type", source_type cannot be nil.')
      end

      if !@page.nil? && @page < 1
        invalid_properties.push('invalid value for "page", must be greater than or equal to 1.')
      end

      if !@per_page.nil? && @per_page > 200
        invalid_properties.push('invalid value for "per_page", must be smaller than or equal to 200.')
      end

      if !@per_page.nil? && @per_page < 0
        invalid_properties.push('invalid value for "per_page", must be greater than or equal to 0.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @source_type.nil?
      source_type_validator = EnumAttributeValidator.new('String', ['openstax_page'])
      return false unless source_type_validator.valid?(@source_type)
      color_validator = EnumAttributeValidator.new('String', ['yellow', 'green', 'blue', 'purple', 'pink'])
      return false unless color_validator.valid?(@color)
      return false if !@page.nil? && @page < 1
      return false if !@per_page.nil? && @per_page > 200
      return false if !@per_page.nil? && @per_page < 0
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] source_type Object to be assigned
    def source_type=(source_type)
      validator = EnumAttributeValidator.new('String', ['openstax_page'])
      unless validator.valid?(source_type)
        fail ArgumentError, 'invalid value for "source_type", must be one of #{validator.allowable_values}.'
      end
      @source_type = source_type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] color Object to be assigned
    def color=(color)
      validator = EnumAttributeValidator.new('String', ['yellow', 'green', 'blue', 'purple', 'pink'])
      unless validator.valid?(color)
        fail ArgumentError, 'invalid value for "color", must be one of #{validator.allowable_values}.'
      end
      @color = color
    end

    # Custom attribute writer method with validation
    # @param [Object] page Value to be assigned
    def page=(page)
      if !page.nil? && page < 1
        fail ArgumentError, 'invalid value for "page", must be greater than or equal to 1.'
      end

      @page = page
    end

    # Custom attribute writer method with validation
    # @param [Object] per_page Value to be assigned
    def per_page=(per_page)
      if !per_page.nil? && per_page > 200
        fail ArgumentError, 'invalid value for "per_page", must be smaller than or equal to 200.'
      end

      if !per_page.nil? && per_page < 0
        fail ArgumentError, 'invalid value for "per_page", must be greater than or equal to 0.'
      end

      @per_page = per_page
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          source_type == o.source_type &&
          scope_id == o.scope_id &&
          source_ids == o.source_ids &&
          color == o.color &&
          page == o.page &&
          per_page == o.per_page
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [source_type, scope_id, source_ids, color, page, per_page].hash
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def build_from_hash(attributes)
      return nil unless attributes.is_a?(Hash)
      self.class.swagger_types.each_pair do |key, type|
        if type =~ /\AArray<(.*)>/i
          # check to ensure the input is an array given that the the attribute
          # is documented as an array but the input is not
          if attributes[self.class.attribute_map[key]].is_a?(Array)
            self.send("#{key}=", attributes[self.class.attribute_map[key]].map { |v| _deserialize($1, v) })
          end
        elsif !attributes[self.class.attribute_map[key]].nil?
          self.send("#{key}=", _deserialize(type, attributes[self.class.attribute_map[key]]))
        end # or else data not found in attributes(hash), not an issue as the data can be optional
      end

      self
    end

    # Deserializes the data based on type
    # @param string type Data type
    # @param string value Value to be deserialized
    # @return [Object] Deserialized data
    def _deserialize(type, value)
      case type.to_sym
      when :DateTime
        DateTime.parse(value)
      when :Date
        Date.parse(value)
      when :String
        value.to_s
      when :Integer
        value.to_i
      when :Float
        value.to_f
      when :BOOLEAN
        if value.to_s =~ /\A(true|t|yes|y|1)\z/i
          true
        else
          false
        end
      when :Object
        # generic object (usually a Hash), return directly
        value
      when /\AArray<(?<inner_type>.+)>\z/
        inner_type = Regexp.last_match[:inner_type]
        value.map { |v| _deserialize(inner_type, v) }
      when /\AHash<(?<k_type>.+?), (?<v_type>.+)>\z/
        k_type = Regexp.last_match[:k_type]
        v_type = Regexp.last_match[:v_type]
        {}.tap do |hash|
          value.each do |k, v|
            hash[_deserialize(k_type, k)] = _deserialize(v_type, v)
          end
        end
      else # model
        temp_model = Api::V0::Bindings.const_get(type).new
        temp_model.tap{|tm| tm.build_from_hash(value)}
      end
    end

    # Returns the string representation of the object
    # @return [String] String presentation of the object
    def to_s
      to_hash.to_s
    end

    # to_body is an alias to to_hash (backward compatibility)
    # @return [Hash] Returns the object in the form of hash
    def to_body
      to_hash
    end

    # Returns the object in the form of hash
    # @return [Hash] Returns the object in the form of hash
    def to_hash
      hash = {}
      self.class.attribute_map.each_pair do |attr, param|
        value = self.send(attr)
        next if value.nil?
        hash[param] = _to_hash(value)
      end
      hash
    end

    # Outputs non-array value in the form of hash
    # For object, use to_hash. Otherwise, just return the value
    # @param [Object] value Any valid value
    # @return [Hash] Returns the value in the form of hash
    def _to_hash(value)
      if value.is_a?(Array)
        value.compact.map { |v| _to_hash(v) }
      elsif value.is_a?(Hash)
        {}.tap do |hash|
          value.each { |k, v| hash[k] = _to_hash(v) }
        end
      elsif value.respond_to? :to_hash
        value.to_hash
      else
        value
      end
    end
  end
end
