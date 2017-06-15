class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value != "" && !(value =~  /^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$/)
      record.errors[attribute] << (options[:message] || "Vui lòng nhập đúng định dạng số điện thoại." )
    end
  end
end