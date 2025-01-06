class CreateOrganizationEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :organization_employees, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.integer :role

      t.timestamps
    end
  end
end
