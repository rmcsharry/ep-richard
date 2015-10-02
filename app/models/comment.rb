class Comment < ActiveRecord::Base
  validates :body, presence: true
  validates :parent, presence: true

  belongs_to :parent
  belongs_to :game
  belongs_to :pod

  before_create :set_pod

  def parent_name
    name = self.parent.name.split
    first_name = name[0]

    if name.count == 1
      "#{first_name}"
    else
      last_name  = name[1].slice(0)
      "#{first_name} #{last_name}."
    end

  end

  def set_pod
    self.pod = self.parent.pod
  end

end
