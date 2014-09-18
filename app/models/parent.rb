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
    account_sid = 'AC38de11026e8717f75248f84136413f7d'
    auth_token = 'f82546484dc3dfc96989f5930a13e508'

    @client = Twilio::REST::Client.new account_sid, auth_token

    @client.account.messages.create({
      :from => '+441290211660',
      :to => self.phone,
      :body => "Hi #{self.first_name}, welcome to EasyPeasy! Open this link to start: http://play.easypeasyapp.com/#/#{self.slug}/games"
    })
  end

  def first_name
    self.name.split(" ")[0]
  end

end
