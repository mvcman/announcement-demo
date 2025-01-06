class Organization < ApplicationRecord
    has_many :organization_employees, dependent: :destroy 

    has_many :departments, dependent: :destroy

    has_many :users, through: :organization_employees 
    has_many :projects, dependent: :destroy

    has_many :announcements, dependent: :destroy 

    has_many :announcement_recipients, as: :announceable, dependent: :destroy

    validates :name, presence: true 

    has_one_attached :logo
end
