class Pod < ActiveRecord::Base
  validates :name, presence: true

  has_one :pod_admin
  has_many :parents
  has_many :comments
end
