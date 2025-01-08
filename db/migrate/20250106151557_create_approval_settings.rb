class CreateApprovalSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :approval_settings, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.integer :require_approvals

      t.timestamps
    end
  end
end
