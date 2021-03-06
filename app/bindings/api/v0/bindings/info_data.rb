=begin
#OpenStax Highlights API

#The highlights API for OpenStax.  Requests to this API should include `application/json` in the `Accept` header.  The desired API version is specified in the request URL, e.g. `[domain]/highlights/api/v0/highlights`. While the API does support a default version, that version will change over time and therefore should not be used in production code! 

OpenAPI spec version: 0.1.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.13

=end

require 'date'

module Api::V0::Bindings
  class InfoData
    # The total number of notes/annotations
    attr_accessor :total_notes

    # The number of users with notes
    attr_accessor :num_users_with_notes

    # The average length (chars) of a note
    attr_accessor :avg_note_length

    # The median length (chars) of a note
    attr_accessor :median_note_length

    # The max length (chars) of a note for any user
    attr_accessor :max_note_length

    # The total number of highlights
    attr_accessor :total_highlights

    # The number of users with highlights
    attr_accessor :num_users_with_highlights

    # The average number of highlights per user
    attr_accessor :avg_highlights_per_user

    # The median number of highlights per user
    attr_accessor :median_highlights_per_user

    # The max number of highlights used by any one user
    attr_accessor :max_num_highlights_any_user

    # The number of users that have greater than 200 highlights on any page
    attr_accessor :num_users_gt_200_highlights_per_page

    # The number of users that have greater than 10 highlights
    attr_accessor :num_users_gt_10_highlights

    # The number of users that have greater than 50 highlights
    attr_accessor :num_users_gt_50_highlights

    # The total number of users
    attr_accessor :total_users

    # The precalculated start time
    attr_accessor :gen_started_at

    # The precalculated end time
    attr_accessor :gen_ended_at

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'total_notes' => :'total_notes',
        :'num_users_with_notes' => :'num_users_with_notes',
        :'avg_note_length' => :'avg_note_length',
        :'median_note_length' => :'median_note_length',
        :'max_note_length' => :'max_note_length',
        :'total_highlights' => :'total_highlights',
        :'num_users_with_highlights' => :'num_users_with_highlights',
        :'avg_highlights_per_user' => :'avg_highlights_per_user',
        :'median_highlights_per_user' => :'median_highlights_per_user',
        :'max_num_highlights_any_user' => :'max_num_highlights_any_user',
        :'num_users_gt_200_highlights_per_page' => :'num_users_gt_200_highlights_per_page',
        :'num_users_gt_10_highlights' => :'num_users_gt_10_highlights',
        :'num_users_gt_50_highlights' => :'num_users_gt_50_highlights',
        :'total_users' => :'total_users',
        :'gen_started_at' => :'gen_started_at',
        :'gen_ended_at' => :'gen_ended_at'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'total_notes' => :'Integer',
        :'num_users_with_notes' => :'Integer',
        :'avg_note_length' => :'Integer',
        :'median_note_length' => :'Integer',
        :'max_note_length' => :'Integer',
        :'total_highlights' => :'Integer',
        :'num_users_with_highlights' => :'Integer',
        :'avg_highlights_per_user' => :'Integer',
        :'median_highlights_per_user' => :'Integer',
        :'max_num_highlights_any_user' => :'Integer',
        :'num_users_gt_200_highlights_per_page' => :'Integer',
        :'num_users_gt_10_highlights' => :'Integer',
        :'num_users_gt_50_highlights' => :'Integer',
        :'total_users' => :'Integer',
        :'gen_started_at' => :'String',
        :'gen_ended_at' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'total_notes')
        self.total_notes = attributes[:'total_notes']
      end

      if attributes.has_key?(:'num_users_with_notes')
        self.num_users_with_notes = attributes[:'num_users_with_notes']
      end

      if attributes.has_key?(:'avg_note_length')
        self.avg_note_length = attributes[:'avg_note_length']
      end

      if attributes.has_key?(:'median_note_length')
        self.median_note_length = attributes[:'median_note_length']
      end

      if attributes.has_key?(:'max_note_length')
        self.max_note_length = attributes[:'max_note_length']
      end

      if attributes.has_key?(:'total_highlights')
        self.total_highlights = attributes[:'total_highlights']
      end

      if attributes.has_key?(:'num_users_with_highlights')
        self.num_users_with_highlights = attributes[:'num_users_with_highlights']
      end

      if attributes.has_key?(:'avg_highlights_per_user')
        self.avg_highlights_per_user = attributes[:'avg_highlights_per_user']
      end

      if attributes.has_key?(:'median_highlights_per_user')
        self.median_highlights_per_user = attributes[:'median_highlights_per_user']
      end

      if attributes.has_key?(:'max_num_highlights_any_user')
        self.max_num_highlights_any_user = attributes[:'max_num_highlights_any_user']
      end

      if attributes.has_key?(:'num_users_gt_200_highlights_per_page')
        self.num_users_gt_200_highlights_per_page = attributes[:'num_users_gt_200_highlights_per_page']
      end

      if attributes.has_key?(:'num_users_gt_10_highlights')
        self.num_users_gt_10_highlights = attributes[:'num_users_gt_10_highlights']
      end

      if attributes.has_key?(:'num_users_gt_50_highlights')
        self.num_users_gt_50_highlights = attributes[:'num_users_gt_50_highlights']
      end

      if attributes.has_key?(:'total_users')
        self.total_users = attributes[:'total_users']
      end

      if attributes.has_key?(:'gen_started_at')
        self.gen_started_at = attributes[:'gen_started_at']
      end

      if attributes.has_key?(:'gen_ended_at')
        self.gen_ended_at = attributes[:'gen_ended_at']
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
          total_notes == o.total_notes &&
          num_users_with_notes == o.num_users_with_notes &&
          avg_note_length == o.avg_note_length &&
          median_note_length == o.median_note_length &&
          max_note_length == o.max_note_length &&
          total_highlights == o.total_highlights &&
          num_users_with_highlights == o.num_users_with_highlights &&
          avg_highlights_per_user == o.avg_highlights_per_user &&
          median_highlights_per_user == o.median_highlights_per_user &&
          max_num_highlights_any_user == o.max_num_highlights_any_user &&
          num_users_gt_200_highlights_per_page == o.num_users_gt_200_highlights_per_page &&
          num_users_gt_10_highlights == o.num_users_gt_10_highlights &&
          num_users_gt_50_highlights == o.num_users_gt_50_highlights &&
          total_users == o.total_users &&
          gen_started_at == o.gen_started_at &&
          gen_ended_at == o.gen_ended_at
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [total_notes, num_users_with_notes, avg_note_length, median_note_length, max_note_length, total_highlights, num_users_with_highlights, avg_highlights_per_user, median_highlights_per_user, max_num_highlights_any_user, num_users_gt_200_highlights_per_page, num_users_gt_10_highlights, num_users_gt_50_highlights, total_users, gen_started_at, gen_ended_at].hash
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
