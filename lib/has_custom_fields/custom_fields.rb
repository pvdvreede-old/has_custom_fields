module HasCustomFields
  module CustomFields
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def has_custom_fields(options={})
        after_initialize :init_custom_fields
        after_save :save_custom_values
        after_find :find_custom_values
      end
    end

    def init_custom_fields
      @field_names ||= []
      @field_values ||= []
    end

    def for_custom_fields
      raise "Need a block" unless block_given?
      @field_names.each do |field|
        field_value = find_value_field(field.id)
        value = field_value.nil? ? "" : field_value.field_value
        yield field.field_name, value, field.field_type
      end
    end

    def has_custom_field?(name)
      @field_names.to_a.count { |f| f.field_name == name.to_s } > 0
    end

    def save_custom_values
      @field_values.each do |field_value|
        if field_value.changed? || !field_value.persisted?
          field_value.save!
        end
      end
    end

    def find_custom_values
      unless self.class.name == "CustomField" || self.class.name == "CustomFieldValue"
        @field_names = HasCustomFields::CustomField.where(:belongs_to => self.class.name)
        @field_values = HasCustomFields::CustomFieldValue.where(:belongs_to_id => self.id)

        @field_names.each do |field|
          field_name = field.field_name.from_sentance_to_snake_case
          define_singleton_method field_name.to_sym do
            value_field = find_value_field(field.id)
            return nil if value_field.nil?
            case field.field_type
            when 'string'
              value_field.field_value
            end
          end

          define_singleton_method "#{field_name}=".to_sym do |value_to_set|
            value_field = find_value_field(field.id)
            if value_field.nil?
              value_field = CustomFieldValue.new(
                :belongs_to_id => self.id,
                :custom_field_id => field.id
              )
              @field_values << value_field
            end
            value_field.field_value = value_to_set
          end
        end
      end
    end

    def method_missing(name, *args, &block)
      if name.to_s =~ /^(.*)=$/
        value_field = find_value_field_from_name($1)
        unless value_field.nil?
          value_field.value = args[0]
        else
          name_field = find_name_field($1)
          return super if name_field.nil?
          @field_values << CustomFieldValue.new(:value => args[0], :custom_field_id => name_field.id)
          @field_values.last
        end
      else
        value_field = find_value_field_from_name(name.to_s)
        return super if value_field.nil?
        value_field.field_value
      end
    end

    private

    def find_value_field(id)
      @field_values.find { |v| id == v.custom_field_id }
    end

    def find_value_field_from_name(name)
      name_field = find_name_field(name)
      return nil if name_field.nil?
      find_value_field(name_field.id)
    end

    def find_name_field(name)
      @field_names.find { |n| n.field_name == name } unless @field_names.nil?
    end

  end
end

class String
  def from_sentance_to_snake_case
    self.gsub(/\s/, '_').downcase
  end
end

ActiveRecord::Base.send :include, HasCustomFields::CustomFields
