class Pod < ActiveRecord::Base
  has_one :pod_admin
  has_many :parents
end
