class Approval < ApplicationRecord
  belongs_to :approval_request
  belongs_to :approver, class_name: "User", foreign_key: "user_id"

  enum :status, %w[ pending approved denied ].index_by(&:itself), default: :pending
end
