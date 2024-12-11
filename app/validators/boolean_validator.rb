# BooleanValidator prevents Rails type conversion from storing the true/false value as an unexpected value
# when it is received as a string.

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
