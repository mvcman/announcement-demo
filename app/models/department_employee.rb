class DepartmentEmployee < ApplicationRecord
  belongs_to :department
  belongs_to :user

  validate :user_belongs_to_same_organization 

  private 

  def user_belongs_to_same_organization 
    department_org_id = department.organization_id 
    user_org_ids = user.organizations.pluck(:id)

    unless user_org_ids.include?(department_org_id)
      errors.add(:user, "must belong to the same organization as the department")
    end

    if DepartmentEmployee.joins(:department).where(user_id: user_id).where(departments: { organization_id: department_org_id }).exists?
      errors.add(:user, "Already belongs to another department in this organization")
    end
  end
end
