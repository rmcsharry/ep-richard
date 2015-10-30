class Parent < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
  # validates :phone, uniqueness: true
  validate :phone_format
  before_create :set_slug

  belongs_to :pod
  has_many :comments, dependent: :destroy

  def set_slug
    if self.slug.nil?
      self.slug = SecureRandom.urlsafe_base64(5)
    end
  end

  def phone_format
    if /^07\d{9}$/.match(phone)
      return true
    else
      errors.add(:phone, "should be 11 digits and start 07")
    end
  end

  def send_welcome_sms
    if Rails.env == "production"
      account_sid = 'AC38de11026e8717f75248f84136413f7d'
      auth_token = 'f82546484dc3dfc96989f5930a13e508'

      @client = Twilio::REST::Client.new account_sid, auth_token

      @client.account.messages.create({
        :from => '+441290211660',
        :to => self.phone,
        :body => "Hi #{self.first_name}, welcome to EasyPeasy: an app for parents that sends you fun, simple game ideas to support your child's early development. Open this link to start: http://play.easypeasyapp.com/#/#{self.slug}/games"
      })
    end
  end

  def log_welcome_sms_sent
    self.welcome_sms_sent = true
    self.save
  end

  def first_name
    self.name.split(" ")[0]
  end

  def should_notify?
    return false if !self.pod.go_live_date
    return false if self.pod.week_number == 0
    return false if !Game.non_default[self.pod.week_number - 1]
    return false if self.last_notification && self.last_notification > Date.today - 7.days
    return true
  end

  def notify
    message = "Hello #{self.first_name}, your new game is now available on EasyPeasy. Open this link to see it: http://play.easypeasyapp.com/#/#{self.slug}/games/"
    if should_notify?
      self.last_notification = Date.today
      send_sms(message) if self.save
      return true
    else
      return false
    end
  end

  def send_sms(message)
    if Rails.env == "production"
      account_sid = 'AC38de11026e8717f75248f84136413f7d'
      auth_token = 'f82546484dc3dfc96989f5930a13e508'
      @client = Twilio::REST::Client.new account_sid, auth_token
      @client.account.messages.create({
        :from => '+441290211660',
        :to => self.phone,
        :body => message
      })
    end
  end

end
