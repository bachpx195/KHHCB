class Dashboard < ApplicationRecord
  has_attached_file :image, styles: { large: "600x600>", medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/nophoto.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def self.search(search)
    search ? where("col1 LIKE ?", "%#{search[:col1]}%") : all
  end
end
