class Province < ApplicationRecord
  validates :name,:presence => { :message => I18n.t(:province_name ) +" "+ I18n.t(:require )}, length: { maximum: 255 }
  def self.search(search)
    search ? where("name LIKE ?", "%#{search[:name]}%") : all
  end
end
