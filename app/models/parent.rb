class Parent < ActiveRecord::Base
  validates :name, presence: true
  validates :phone, presence: true
  validates :phone, uniqueness: true

  belongs_to :pod
end
