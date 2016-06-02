class PodAdmin < Admin
include NilifyBlanks

  validates :pod, presence: true
  validates :preferred_name, presence: true

  nilify_blanks only: [:name]

  belongs_to :pod

  def should_send_analytics_email?
    # if making changes here, check should_notify? in parent.rb
    return false if !self.pod.go_live_date
    return false if self.pod.week_number == 0
    # return false if !Game.non_default[self.pod.week_number - 1]
    return false if self.last_analytics_email_sent && self.last_analytics_email_sent > Date.today - 7.days
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
  
  def send_greetings_email
    if self.created_at == Date.yesterday
      PodAdminMailer.greetings_email(self).deliver
      return true
    else
      return false
    end
  end
  
  def send_trial_reminder_email(support_person_name=nil)
    if self.pod.is_in_trial? && (self.pod.days_left == 7 || self.pod.days_left == 2)
      PodAdminMailer.trial_reminder_email(self, support_person_name).deliver
      return true
    else
      return false
    end
  end
  
  def send_account_already_exists_email
    PodAdminMailer.account_already_exists_email(self).deliver
    return true
  end
end
