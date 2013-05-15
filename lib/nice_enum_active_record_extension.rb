module NiceEnumActiveRecordExtension
  extend ActiveSupport::Concern

  module ClassMethods

  private

    def map_enum(attribute, enum_type)
      define_method("#{attribute.to_s}=") { |enum_or_string|
        write_attribute(
          attribute,
          enum_or_string.respond_to?(:value) ? enum_or_string.value : enum_or_string)
      }
      define_method(attribute.to_s) {
        enum_type.new read_attribute(attribute)
      }
    end
  end
end