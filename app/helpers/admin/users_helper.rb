module Admin::UsersHelper
  def formatted_datetime(datetime)
    datetime.strftime("%A, %d %b %Y %l:%M %p")
  end
end
