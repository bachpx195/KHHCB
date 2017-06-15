class Banner < ApplicationRecord
  has_attached_file :image, styles: { thumb: "100x100>", square: "300x300>", rectangle: "800*100>" }, default_url: "/images/:style/nophoto.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates_format_of :url, :with => URI::regexp(%w(http https)), length:{maximum:255},  :message => I18n.t(:banner_url ) +" "+ I18n.t(:valid )
  validates :name, :presence => { :message => I18n.t(:banner_name ) +" "+ I18n.t(:require )}, length: { maximum: 255 }
  validates :image, :presence => { :message => I18n.t(:banner_image ) +" "+ I18n.t(:require )}, length:{maximum:255}
  validates :status, :presence => { :message => I18n.t(:banner_status ) +" "+ I18n.t(:require )}, length: { maximum: 11 }

  def self.search(search)
    search ? where("name LIKE ?", "%#{search[:name]}%") : all
  end

end
