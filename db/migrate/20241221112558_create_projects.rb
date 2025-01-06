class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects, id: :uuid do |t|
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.string :description
      t.integer :status

      t.timestamps
    end
  end
end
