class AddColumnToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :invitation_token_digest, :string
  end
end
