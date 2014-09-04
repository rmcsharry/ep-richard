class PodAdmin < Admin
  validates :pod, presence: true
  belongs_to :pod
end
