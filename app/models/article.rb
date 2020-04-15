class Article < ApplicationRecord
    has_many :comments, as: :commentable
    belongs_to :user
    validates :title, presence: true
    validates :text, length: { minimum: 10 }

    scope :search, -> (token) { where("title LIKE :token", token: "%#{token}%") }  

    self.per_page = 3
end