class PodAdmin < Admin
  validates :pod, presence: true

  belongs_to :pod

  def should_send_analytics_email?
    # if making changes here, check should_notify? in parent.rb
    # return false if !self.pod.go_live_date
    # return false if self.pod.week_number == 0
    # # return false if !Game.non_default[self.pod.week_number - 1]
    # return false if self.last_analytics_email_sent && self.last_analytics_email_sent > Date.today - 7.days
    return true
  end

  def send_analytics_email
    if should_send_analytics_email?
      self.last_analytics_email_sent = Date.today
      PodAdminMailer.analytics_email(self).deliver if self.save
      return true
    else
      return false
    end
  end
end
