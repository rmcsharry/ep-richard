class Parent < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
  validates :phone, uniqueness: true
  before_create :set_slug

  belongs_to :pod
  has_many :comments, dependent: :destroy

  def set_slug
    if self.slug.nil?
      self.slug = SecureRandom.urlsafe_base64(5)
    end
  end

end
