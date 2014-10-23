class ShortenedUrl < ActiveRecord::Base
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, :submitter, presence: true
  # validates :submitter_id, presence: true
  
  belongs_to(
    :submitter,
    class_name: "User",
    foreign_key: :submitter_id,
    primary_key: :id
  )
  
  has_many(
    :visits,
    class_name: "Visit",
    foreign_key: :shortened_url_id,
    primary_key: :id
  )
  
  has_many(
    :visitors,
    -> { distinct },
    through: :visits, 
    source: :visitor
  ) 
  
  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :shortened_url_id,
    primary_key: :id
  )
  
  has_many(
    :tag_topics,
    through: :taggings,
    source: :tag_topic
  )
  
  def self.random_code
    loop do
      code = SecureRandom::urlsafe_base64
      return code unless self.exists?(:short_url => code)
    end
  end
  
  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(
      submitter_id: user.id, 
      long_url: long_url,
      short_url: ShortenedUrl.random_code
      )
  end
  
  def num_clicks
    visits.select(:visitor_id).count
  end
  
  def num_unique
    visitors.count
  end
  
  def num_recent_uniques
    visits
      .select(:visitor_id)
      .distinct
      .where("created_at > ?", 10.minutes.ago)
      .count
  end
  
  def self.most_tagged
    max_tag = Tagging.group("shortened_url_id").count
    short_id = max_tag.max_by { |k, v| v }.first
    ShortenedUrl.find(short_id)
  end
  
end