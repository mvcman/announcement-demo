class Organization < ApplicationRecord
    has_many :organization_employees, dependent: :destroy 

    has_many :departments, dependent: :destroy

    has_many :users, through: :organization_employees 
    has_many :projects, dependent: :destroy

    has_many :announcements, dependent: :destroy 

    has_many :announcement_recipients, as: :announceable, dependent: :destroy

    has_many :approval_settings, dependent: :destroy
    has_many :approval_requests, dependent: :destroy


    validates :name, presence: true 

    has_one_attached :logo

    def approvers_count 
        approval_settings.find_by(organization: self).require_approvals
    end
end
