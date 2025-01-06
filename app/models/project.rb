class Project < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  enum status: { pending: 0, completed: 1 }
end
