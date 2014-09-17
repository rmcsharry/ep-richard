class Parent < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
  validates :phone, uniqueness: true
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

end
