=begin
#OpenStax Highlights API

#The highlights API for OpenStax.  Requests to this API should include `application/json` in the `Accept` header.  The desired API version is specified in the request URL, e.g. `[domain]/highlights/api/v0/highlights`. While the API does support a default version, that version will change over time and therefore should not be used in production code! 

OpenAPI spec version: 0.1.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.9

=end

require 'date'

module Api::V0::Bindings
  class InfoResults
    # How long the request took (ms)
    attr_accessor :overall_took_ms

    # Current version of Postgres
    attr_accessor :postgres_version

    # Name of deployed environment
    attr_accessor :env_name

    # Accounts environment name
    attr_accessor :accounts_env_name

    # Amazon machine image id
    attr_accessor :ami_id

    # Git sha
    attr_accessor :git_sha

    attr_accessor :data

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'overall_took_ms' => :'overall_took_ms',
        :'postgres_version' => :'postgres_version',
        :'env_name' => :'env_name',
        :'accounts_env_name' => :'accounts_env_name',
        :'ami_id' => :'ami_id',
        :'git_sha' => :'git_sha',
        :'data' => :'data'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'overall_took_ms' => :'Integer',
        :'postgres_version' => :'String',
        :'env_name' => :'String',
        :'accounts_env_name' => :'String',
        :'ami_id' => :'String',
        :'git_sha' => :'String',
        :'data' => :'InfoData'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'overall_took_ms')
        self.overall_took_ms = attributes[:'overall_took_ms']
      end

      if attributes.has_key?(:'postgres_version')
        self.postgres_version = attributes[:'postgres_version']
      end

      if attributes.has_key?(:'env_name')
        self.env_name = attributes[:'env_name']
      end

      if attributes.has_key?(:'accounts_env_name')
        self.accounts_env_name = attributes[:'accounts_env_name']
      end

      if attributes.has_key?(:'ami_id')
        self.ami_id = attributes[:'ami_id']
      end

      if attributes.has_key?(:'git_sha')
        self.git_sha = attributes[:'git_sha']
      end

      if attributes.has_key?(:'data')
        self.data = attributes[:'data']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      true
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          overall_took_ms == o.overall_took_ms &&
          postgres_version == o.postgres_version &&
          env_name == o.env_name &&
          accounts_env_name == o.accounts_env_name &&
          ami_id == o.ami_id &&
          git_sha == o.git_sha &&
          data == o.data
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [overall_took_ms, postgres_version, env_name, accounts_env_name, ami_id, git_sha, data].hash
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
