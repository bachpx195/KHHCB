class UserAdit < ApplicationRecord
  belongs_to :cource
  belongs_to :user

  self.per_page = 3
end
