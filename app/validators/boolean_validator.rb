# BooleanValidator prevents Rails type conversion from storing the true/false value as an unexpected value
# when it is received as a string.

class BooleanValidator < ActiveModel::EachValidator
  def validate_each(record, attr, _value)
    raw_value = record.public_send("#{attr}_before_type_cast")
    record.errors.add(attr, "must be true or false.") unless %w[true false 1 0].include?(raw_value.to_s.downcase)
  end
end
