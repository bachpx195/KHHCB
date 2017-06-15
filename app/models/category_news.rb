class CategoryNews < ApplicationRecord
  has_many :news
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 255}
  def self.search(search)
    search ? where("name LIKE ?", "%#{search[:name]}%") : all
  end
end
