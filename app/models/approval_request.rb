class ApprovalRequest < ApplicationRecord
  belongs_to :requester, class_name: "User", foreign_key: "user_id"
  belongs_to :organization
  
  has_many_attached :images, dependent: :purge_later
  has_many :approvals, dependent: :destroy

  enum :status, %w[ pending in_progress approved denied ].index_by(&:itself), default: :pending

  def request_status 
    return "denied" if approvals.find_by(status: "denied").present?
    return "in_progress" if approvals.count > 0 && approvals.count < organization.approvers_count
    return "approved" if approvals.where(status: "approved").count == organization.approvers_count
    "pending"
  end 

  def approvers 
    User.includes(:organization_employees).where(organization_employees: { organization: organization, role: ["admin", "approver"] })
  end

  def taken_action(user) 
    approvals.find_by(approver: user)
  end
end
