class CreateApprovalRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :approval_requests, id: :uuid do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.string :status

      t.timestamps
    end
  end
end
