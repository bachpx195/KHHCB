class Tag < ApplicationRecord

  has_many :cource_tags
  has_many :cources, :through => :cource_tags

  validates :name,:presence => { :message => I18n.t(:tag_name ) +" "+ I18n.t(:require )}, length: { maximum: 255 }
  def self.search(search)
    search ? where("name LIKE ?", "%#{search[:name]}%") : all
  end
end
