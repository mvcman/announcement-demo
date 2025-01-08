class User < ApplicationRecord
    require "securerandom"
    has_many :sessions, dependent: :destroy
    has_one :profile, dependent: :destroy
    has_many :organization_employees, dependent: :destroy 
    has_many :organizations, through: :organization_employees

    has_many :announcement_recipients, as: :announceable, dependent: :destroy

    has_many :projects, dependent: :destroy

    has_many :department_employees, dependent: :destroy
    has_many :departments, through: :department_employees

    has_many :approval_requests, dependent: :destroy 
    has_many :approvals, dependent: :destroy

    # after_create :create_default_profile
    MINIMUM_PASSWORD_LENGTH = 8
    has_secure_password

    validates :password, length: { minimum: MINIMUM_PASSWORD_LENGTH }
    validates :email, presence: true, uniqueness: true 

    normalizes :email, with: ->(email) { email.strip.downcase } 

    generates_token_for :password_reset, expires_in: 1.hour do 
        password_salt.last(10)
    end

    generates_token_for :invitation, expires_in: 1.hour do 
        SecureRandom.base64(10)
    end
end
