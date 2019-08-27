class Entry < ApplicationRecord
  belongs_to :blog
  has_many :comments

  validates :title, presence: true
  validates :body, presence: true
end
