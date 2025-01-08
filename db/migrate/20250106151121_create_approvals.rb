class CreateApprovals < ActiveRecord::Migration[7.1]
  def change
    create_table :approvals, id: :uuid do |t|
      t.references :approval_request, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.text :comment
      t.string :status

      t.timestamps
    end
  end
end
