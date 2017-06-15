class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value != "" && !(value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
      record.errors[attribute] << (options[:message] || "Vui lòng nhập đúng định dạng email." )
    end
  end
end