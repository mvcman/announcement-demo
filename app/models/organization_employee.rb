class OrganizationEmployee < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum role: { member: 0, admin: 1 }

  validates :role, presence: true 
  validate :cannot_change_role_if_only_one_admin, on: :update 


  private 

  def cannot_change_role_if_only_one_admin 
    return if organization.organization_employees.where(role: 1).count > 1

    if admin? 
      erros.add(:base, "Role cannot be changes because this is the only admin.")
    end
  end
end
