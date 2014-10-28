class User < ActiveRecord::Base
  validates :username, presence: true
  
  has_many(
    :contacts
  )

  has_many(
    :contact_shares,
    class_name: "ContactShare",
    foreign_key: :user_id,
    primary_key: :id,
  )
  
  has_many(
    :shared_contacts,
    through: :contact_shares,
    source: :contact
  )
  
  

end
