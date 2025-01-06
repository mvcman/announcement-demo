class AnnouncementRecipient < ApplicationRecord
  belongs_to :announcement
  belongs_to :announceable, polymorphic: true 
end
