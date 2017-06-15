class Group < ApplicationRecord
  def self.search(search)
    validates :name, presence: true, length:{maximum:30}, uniqueness: true
    validates :description, presence: true, length:{maximum:255}
    search ? where("name LIKE ?", "%#{search[:name]}%") : all
  end
end
