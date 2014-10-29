class Cat < ActiveRecord::Base
  SEX_TYPES = ['M', 'F']

  COLOR_TYPES = ['red', 'green', 'blue', 'black', 'white', 'invisible']

  validates :birth_date, :color, :name, :sex, presence: true
  validates :color, inclusion: { in: COLOR_TYPES }

  validates :sex, inclusion: {in: SEX_TYPES }
  validate :timeliness

  has_many :cat_rental_requests, dependent: :destroy

  def timeliness
     if self.birth_date.nil? || self.birth_date >= Time.now
       errors[:birth_date] << "birthdate is not valid"
     end
  end

  def age
    time_ago_in_words(Time.now - self.birth_date)
  end
end
