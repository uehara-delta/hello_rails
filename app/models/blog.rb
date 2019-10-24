class Blog < ApplicationRecord
  belongs_to :user
  has_many :entries

  validates :title, presence: true
end
