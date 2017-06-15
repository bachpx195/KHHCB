class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value != "" && !(value =~ URI::regexp(%w(http https)))
      record.errors[attribute] << (options[:message] || "Vui lòng nhập đúng định dạng url.")
    end
  end
end
