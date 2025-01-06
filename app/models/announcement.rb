class Announcement < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :organization 

  has_many :announcement_recipients, dependent: :destroy 

  validates :title, :content, :severity, presence: true

  enum :severity, %w[ low high ].index_by(&:itself), default: :low
end
