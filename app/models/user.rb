class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :group
  has_many :user_adits
  # has_many :user_adits
  # has_many :cources, :through => :user_adits

  before_validation :assign_group

  has_attached_file :avatar, styles: { thumb: "100x100>" }, default_url: "/images/:style/nophoto.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :first_name, :last_name, length: { maximum: 255 }, allow_blank: false
  validates :address, :organization, length: { maximum: 255 }
  validates :password, length: 6..20
  validates :email, email: true
  validates :phone, phone: true
  validates :website, :facebook, url: true

  private
  def assign_group
    self.group ||= Group.find_by :level => 1
  end

  def self.search(search)
    search ? where("first_name LIKE ?", "%#{search[:first_name]}%") : all
  end

end
