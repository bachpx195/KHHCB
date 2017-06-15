class Cource < ApplicationRecord

  include ActiveRecord::Validations


  belongs_to :category
  belongs_to :user
  belongs_to :province
  has_many :user_adits
  has_many :cource_tags
  # has_many :tags, :through => :cource_tags

  has_attached_file :image, styles: {large: "300x300>", medium: "300x300>", thumb: "100x100>"}, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates :name, presence: true, length: {maximum: 30}
  validates :organization_name, :representative, length: {maximum: 30}
  validates :start_date, presence: true
  validates :cource_date, presence: true
  validates :category_id, presence: true
  validates :address, presence: true, length: {maximum: 255}
  validates :organization_name, presence: true, length: {maximum: 255}
  validates :cost, presence: true, length: {maximum: 20},:numericality => { :greater_than_or_equal_to => 0 }
  validates :status, presence: true
  validates :email, :organization_email, email: true
  validates :cost_description, :promotion_description, length: {maximum: 255}
  validates :organization_website, url: true
  validates :organization_phone, :hotline, phone: true
  # # validates_format_of :image, :with => %r{\.(png|jpg|jpeg)$}i, :message => "Định dạng hình ảnh không đúng

  def self.searchID(search)
    puts 'search ' + search.to_s
    if search
      find(:first, :conditions => ['name LIKE ?', "%#{search}%"])
    end
    search ? where("name LIKE ?", "%#{search[:name]}%") : all
  end

  self.per_page = 10

  def self.search(search)
    search ? where("name  LIKE ?", "%#{search[:name]}%") : all
  end

  def self.searchCategory (search)
    if !search[:category].blank?
      where(:category_id => "#{search[:category]}")
    else
      all
    end
  end

  def self.searchProvince(search)
    if !search[:province].blank?
      where(:province_id => "#{search[:province]}")
    else
      all
    end
  end


  def self.searchCost(search)
    if search[:cost]== "1"
      where("cost  != 0 ")
    elsif search[:cost] == "0"
      where("cost = 0 ")
    else
      all
    end
  end

  def self.searchTime(search)
    time = Date.today
    if search[:time] == "1"
      where("start_date > ?", time)
    elsif search[:time] == "3"
      where("end_date < ?", time)
    elsif search[:time] == "2"
      where("start_date < ?", time).merge(where("end_date > ?", time))
    else
      all
    end
  end

end