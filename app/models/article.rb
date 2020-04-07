class Article < ApplicationRecord
    has_many :comments, dependent: :destroy
    validates :title, presence: true,
                    length: { minimum: 5 }

    scope :search, -> (token) { where("title LIKE :token", token: "%#{token}%") }
    
end
