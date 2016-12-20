# Preview all emails at http://localhost:3000/rails/mailers/activity
class ActivityPreview < ActionMailer::Preview

  def daily
    ActivityMailer.daily(Date.today)
  end

end
