class Category < ApplicationRecord

  # Validate
  validates :name,:presence => { :message => I18n.t(:category_name ) +" "+ I18n.t(:require )}, length: { maximum: 255 }
  validates :description,length: { maximum: 255 }

  # Ranked
  include RankedModel
  ranks :order
  has_many :cources
  # Search
  def self.search(search)
    search ? where("name LIKE ?", "%#{search[:name]}%") : all
  end
end
