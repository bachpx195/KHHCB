class Feedback < ApplicationRecord
  validates :description,:presence => { :message => I18n.t(:feedback_description ) +" "+ I18n.t(:require )}, length: { maximum: 255 }
  def self.search(search)
    search ? where("description LIKE ?", "%#{search[:description]}%") : all
  end
end
