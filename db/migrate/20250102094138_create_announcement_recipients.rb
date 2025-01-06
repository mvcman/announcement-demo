class CreateAnnouncementRecipients < ActiveRecord::Migration[7.1]
  def change
    create_table :announcement_recipients, id: :uuid do |t|
      t.references :announcement, null: false, foreign_key: true, type: :uuid
      t.references :announceable, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
