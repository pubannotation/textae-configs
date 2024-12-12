# In order to clarify the API specification, I would like to restrict the input values
# to '1', 'true', '0', and 'false' for parameters that receive Boolean values.

# However, when using Rails built-in validator, values like 'foo' and 'bar' are also accepted as true.
# This is because Rails built-in validator checks the value after Rails type casting process.
# In Rails' type casting, strings that are not false are converted to true.

# The BooleanValidator checks the value before type casting, and prevents values like 'foo' and 'bar' from being saved as true.
# Example of use: `validates :is_public, boolean: true`

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
