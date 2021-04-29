=begin
#OpenStax Highlights API

#The highlights API for OpenStax.  Requests to this API should include `application/json` in the `Accept` header.  The desired API version is specified in the request URL, e.g. `[domain]/highlights/api/v0/highlights`. While the API does support a default version, that version will change over time and therefore should not be used in production code! 

OpenAPI spec version: 0.1.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.13

=end

require 'date'

module Api::V0::Bindings
  class Highlight
    # The highlight ID.
    attr_accessor :id

    # The type of content that contains the highlight.
    attr_accessor :source_type

    # The ID of the source document in which the highlight is made.  Has source_type-specific constraints (e.g. all lowercase UUID for the 'openstax_page' source_type).  Because source_ids are passed to query endpoints as comma-separated values, they cannot contain commas.
    attr_accessor :source_id

    # Source metadata, eg: {book_version: 14.3}
    attr_accessor :source_metadata

    # The ID of the container for the source in which the highlight is made.  Varies depending on source_type (e.g. is the lowercase, versionless book UUID for the 'openstax_page' source_type).
    attr_accessor :scope_id

    # The ID of the highlight immediately before this highlight.  May be null if there are no preceding highlights in this source.
    attr_accessor :prev_highlight_id

    # The ID of the highlight immediately after this highlight.  May be null if there are no following highlights in this source.
    attr_accessor :next_highlight_id

    attr_accessor :color

    # The anchor of the highlight.
    attr_accessor :anchor

    # The highlighted content.
    attr_accessor :highlighted_content

    # The note attached to the highlight.
    attr_accessor :annotation

    # Location strategies for the highlight. Items should have a schema matching the strategy schemas that have been defined. (`XpathRangeSelector` or `TextPositionSelector`).
    attr_accessor :location_strategies

    # A number whose relative value gives the highlight's order within the source. Its value has no meaning on its own.
    attr_accessor :order_in_source

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
        :'id' => :'id',
        :'source_type' => :'source_type',
        :'source_id' => :'source_id',
        :'source_metadata' => :'source_metadata',
        :'scope_id' => :'scope_id',
        :'prev_highlight_id' => :'prev_highlight_id',
        :'next_highlight_id' => :'next_highlight_id',
        :'color' => :'color',
        :'anchor' => :'anchor',
        :'highlighted_content' => :'highlighted_content',
        :'annotation' => :'annotation',
        :'location_strategies' => :'location_strategies',
        :'order_in_source' => :'order_in_source'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'id' => :'String',
        :'source_type' => :'String',
        :'source_id' => :'String',
        :'source_metadata' => :'Object',
        :'scope_id' => :'String',
        :'prev_highlight_id' => :'String',
        :'next_highlight_id' => :'String',
        :'color' => :'Color',
        :'anchor' => :'String',
        :'highlighted_content' => :'String',
        :'annotation' => :'String',
        :'location_strategies' => :'Array<Object>',
        :'order_in_source' => :'Float'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'id')
        self.id = attributes[:'id']
      end

      if attributes.has_key?(:'source_type')
        self.source_type = attributes[:'source_type']
      end

      if attributes.has_key?(:'source_id')
        self.source_id = attributes[:'source_id']
      end

      if attributes.has_key?(:'source_metadata')
        self.source_metadata = attributes[:'source_metadata']
      end

      if attributes.has_key?(:'scope_id')
        self.scope_id = attributes[:'scope_id']
      end

      if attributes.has_key?(:'prev_highlight_id')
        self.prev_highlight_id = attributes[:'prev_highlight_id']
      end

      if attributes.has_key?(:'next_highlight_id')
        self.next_highlight_id = attributes[:'next_highlight_id']
      end

      if attributes.has_key?(:'color')
        self.color = attributes[:'color']
      end

      if attributes.has_key?(:'anchor')
        self.anchor = attributes[:'anchor']
      end

      if attributes.has_key?(:'highlighted_content')
        self.highlighted_content = attributes[:'highlighted_content']
      end

      if attributes.has_key?(:'annotation')
        self.annotation = attributes[:'annotation']
      end

      if attributes.has_key?(:'location_strategies')
        if (value = attributes[:'location_strategies']).is_a?(Array)
          self.location_strategies = value
        end
      end

      if attributes.has_key?(:'order_in_source')
        self.order_in_source = attributes[:'order_in_source']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @id.nil?
        invalid_properties.push('invalid value for "id", id cannot be nil.')
      end

      if @source_type.nil?
        invalid_properties.push('invalid value for "source_type", source_type cannot be nil.')
      end

      if @source_id.nil?
        invalid_properties.push('invalid value for "source_id", source_id cannot be nil.')
      end

      if @source_id !~ Regexp.new(/(?-mix:^[^,]+$)/)
        invalid_properties.push('invalid value for "source_id", must conform to the pattern /(?-mix:^[^,]+$)/.')
      end

      if @color.nil?
        invalid_properties.push('invalid value for "color", color cannot be nil.')
      end

      if @anchor.nil?
        invalid_properties.push('invalid value for "anchor", anchor cannot be nil.')
      end

      if @highlighted_content.nil?
        invalid_properties.push('invalid value for "highlighted_content", highlighted_content cannot be nil.')
      end

      if @location_strategies.nil?
        invalid_properties.push('invalid value for "location_strategies", location_strategies cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @id.nil?
      return false if @source_type.nil?
      source_type_validator = EnumAttributeValidator.new('String', ['openstax_page'])
      return false unless source_type_validator.valid?(@source_type)
      return false if @source_id.nil?
      return false if @source_id !~ Regexp.new(/(?-mix:^[^,]+$)/)
      return false if @color.nil?
      return false if @anchor.nil?
      return false if @highlighted_content.nil?
      return false if @location_strategies.nil?
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

    # Custom attribute writer method with validation
    # @param [Object] source_id Value to be assigned
    def source_id=(source_id)
      if source_id.nil?
        fail ArgumentError, 'source_id cannot be nil'
      end

      if source_id !~ Regexp.new(/(?-mix:^[^,]+$)/)
        fail ArgumentError, 'invalid value for "source_id", must conform to the pattern /(?-mix:^[^,]+$)/.'
      end

      @source_id = source_id
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          id == o.id &&
          source_type == o.source_type &&
          source_id == o.source_id &&
          source_metadata == o.source_metadata &&
          scope_id == o.scope_id &&
          prev_highlight_id == o.prev_highlight_id &&
          next_highlight_id == o.next_highlight_id &&
          color == o.color &&
          anchor == o.anchor &&
          highlighted_content == o.highlighted_content &&
          annotation == o.annotation &&
          location_strategies == o.location_strategies &&
          order_in_source == o.order_in_source
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [id, source_type, source_id, source_metadata, scope_id, prev_highlight_id, next_highlight_id, color, anchor, highlighted_content, annotation, location_strategies, order_in_source].hash
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def build_from_hash(attributes)
      return nil unless attributes.is_a?(Hash)
      self.class.swagger_types.each_pair do |key, type|
        if type =~ /\AArray<(.*)>/i
          # check to ensure the input is an array given that the attribute
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
