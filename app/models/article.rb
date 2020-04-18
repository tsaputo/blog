# frozen_string_literal: true

class Article < ApplicationRecord
  has_many :comments, as: :commentable
  # add dependant destroy!!!
  belongs_to :user
  validates :title, presence: true
  validates :text, length: { minimum: 10 }

  scope :search, ->(token) { where('title LIKE ?', "%#{token}%") }

  self.per_page = 3
end
