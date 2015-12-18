class PodAdmin < Admin
  validates :pod, presence: true

  belongs_to :pod

  def should_send_analytics_email?
    return false if !self.pod.go_live_date
    return true
  end

  def send_analytics_email
    if should_send_analytics_email?
      PodAdminMailer.analytics_email(self).deliver
      return true
    else
      return false
    end
  end
end
