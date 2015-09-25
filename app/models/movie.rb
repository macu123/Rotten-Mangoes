class Movie < ActiveRecord::Base
  has_many :reviews
  mount_uploader :image, ImageUploader

  validates :title, :director, :description, :release_date, presence: true
  validates :runtime_in_minutes, numericality: {only_integer: true}
  validate :release_date_is_in_the_future

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