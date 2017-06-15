class News < ApplicationRecord
  belongs_to :category_news
  has_attached_file :image, styles: {large: "600x600>", medium: "300x300>", thumb: "100x100>"}, default_url: "/images/:style/nophoto.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates :category_news, presence: true
  validates :title, presence: true, length: {maximum: 255}
  validates :image, length: {maximum: 255}

  def self.search(search)
    search ? where("title LIKE ?", "%#{search[:title]}%") : all
  end

  def self.search_by_category(search)
    search ? where("category_news_id LIKE ?", "%#{search}%") : all
  end



end
