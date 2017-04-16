class PodAdmin < Admin
  
  include NilifyBlanks

  validates :pod, presence: true
  validates :preferred_name, presence: true

  nilify_blanks only: [:name]

  belongs_to :pod
  belongs_to :parent

  after_create :create_dummy_parent

  def create_dummy_parent
    if type == 'PodAdmin'
      self.parent = Parent.create(name: self.name, phone: '07000000000', pod: self.pod)
      self.save
    end
  end

  def get_name
    name = self.preferred_name
    if name.nil? || name == ""
      name = self.name.split(" ")[0] if !self.name.nil?
    end
    if !name.blank?
      name = "#{name},"
    else
      name = ""
    end    
  end

  def should_send_analytics_email?
    # don't send again if sent in the past week (this ensures the pod admin gets it only once a week)
    return false if self.last_analytics_email_sent && self.last_analytics_email_sent > Date.today - 7.days
    return self.pod.should_notify?
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
  
end
