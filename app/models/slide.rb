class Slide < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :url, presence: true, length: { maximum: 255 }
  validates :status, presence: true, length: {maximum: 11}
  has_attached_file :image, styles: { large: "600x600>", medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/nophoto.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def self.search(search)
    search ? where("name LIKE ?", "%#{search[:name]}%") : all
  end
end
