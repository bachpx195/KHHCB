class Config < ApplicationRecord

  validates :code,:presence => { :message => I18n.t(:config_code ) +" "+ I18n.t(:require )}, length: { maximum: 255 }
  validates :value,:presence => { :message => I18n.t(:config_value ) +" "+ I18n.t(:require )}, length: { maximum: 255 }

  def self.search(search)
    search ? where("code LIKE ?", "%#{search[:code]}%") : all
  end
end
