class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie

  validates :user, :movie, :text, presence: true
  validates :rating_out_of_ten, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10}
  before_save :assign_rating_to_zero, unless: :rating_out_of_ten

  protected

  def assign_rating_to_zero
    rating_out_of_ten = 0
  end  
end
