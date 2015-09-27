class Movie < ActiveRecord::Base
  has_many :reviews
  mount_uploader :image, ImageUploader

  validates :title, :director, :description, :release_date, presence: true
  validates :runtime_in_minutes, numericality: {only_integer: true}
  validate :release_date_is_in_the_future

  scope :with_title_or_director, ->(title_or_director) {where("title like ? OR director like ?", "%#{title_or_director}%", "%#{title_or_director}%")}
  scope :duration_longer_than, ->(runtime) {where("runtime_in_minutes > ?", runtime)}
  scope :duration_within_range, ->(min, max) {where("runtime_in_minutes > ? AND runtime_in_minutes <= ?", min, max)}

  def review_average
    if reviews.size > 0
      reviews.sum(:rating_out_of_ten)/reviews.size
    else
      Float::NAN
    end
  end

  protected
  
  def release_date_is_in_the_future
    if release_date.present? && release_date < Date.today
      errors.add(:release_date, "should probably be in the future")
    end
  end
end