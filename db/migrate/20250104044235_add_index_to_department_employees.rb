class AddIndexToDepartmentEmployees < ActiveRecord::Migration[7.1]
  def change
    add_index :department_employees, [:user_id, :department_id], unique: true
  end
end
