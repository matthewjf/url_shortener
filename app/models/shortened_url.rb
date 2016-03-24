class ShortenedUrl < ActiveRecord::Base
  validates :short_url, :long_url, presence: true, uniqueness: true
  validates :long_url, length: { maximum: 1024 }
  validate :too_many_urls, on: :create

  belongs_to :submitter,
    foreign_key: :submitter_id,
    primary_key: :id,
    class_name: :User

  has_many :visits,
    foreign_key: :shortened_url_id,
    primary_key: :id,
    class_name: :Visit

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitors

  def self.random_code
    random_code = nil
    until random_code && !ShortenedUrl.exists?(short_url: random_code)
      random_code = SecureRandom.urlsafe_base64
    end
    random_code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create(submitter_id: user.id, long_url: long_url,
      short_url: ShortenedUrl.random_code)
  end

  def self.prune(n)
    self.all.each do |url|
      url.delete unless url.any_recent_visits?(n)
    end
  end

  def too_many_urls
    if User.find(submitter_id).num_recent_urls > 5
      errors.add(:base, "relax")
    end
  end

  def num_uniques
    visitors.count
  end

  def any_recent_visits?(n)
    Visit.select(:user_id).where("shortened_url_id = ? AND created_at > ?", self.id, n.minutes.ago).count > 0
  end

  def num_recent_uniques
    Visit.select(:user_id).distinct.where("created_at > ?", 10.minutes.ago).count
  end

  def num_clicks
    Visit.select(:user_id).count
  end

end
