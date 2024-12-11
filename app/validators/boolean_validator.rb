class BooleanValidator < ActiveModel::EachValidator
  def validate_each(record, attr, _value)
    before_value = record.public_send("#{attr}_before_type_cast")
    record.errors.add(attr, "must be true or false.") unless %w[true false 1 0].include?(before_value.to_s.downcase)
  end
end
