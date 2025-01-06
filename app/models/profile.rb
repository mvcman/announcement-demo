class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  def full_address 
    [address, city, state, country, pin_code].compact.join(", ") 
  end 

  def full_name 
    first_name + " " + last_name 
  end
end
