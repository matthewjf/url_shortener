class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true

  has_many :submitted_urls,
    foreign_key: :submitter_id,
    primary_key: :id,
    class_name: :ShortenedUrl

  has_many :visits,
    foreign_key: :user_id,
    primary_key: :id,
    class_name: :Visit

  has_many :visited_urls,
    Proc.new { distinct },
    through: :visits,
    source: :shortened_url

  def num_recent_urls
    submitted_urls.count { |url| url.created_at > 1.minute.ago }
  end
end
