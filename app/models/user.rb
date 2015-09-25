class User < ActiveRecord::Base
  has_many :reviews
  has_secure_password

  validates :email, :firstname, :lastname, presence: true
  validates :password, length: { in: 6..20 }, on: :create
  after_destroy :delete_all_related_reviews

  def full_name
    "#{firstname} #{lastname}"
  end

  protected

  def delete_all_related_reviews
    reviews.each do |review|
      review.destroy
    end
  end
end