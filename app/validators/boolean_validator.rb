# BooleanValidator prevents unexpected Rails type conversion.
# For example, it prevents the value like ‘foo’ or ‘bar’ from being saved as true.

class BooleanValidator < ActiveModel::EachValidator
  VALID_VALUES = [
    "true", "1", 1,
    "false", "0", 0
  ].freeze

  def validate_each(record, attr, _value)
    raw_value = record.public_send("#{attr}_before_type_cast")
    record.errors.add(attr, "must be true or false.") unless VALID_VALUES.include?(raw_value)
  end
end
