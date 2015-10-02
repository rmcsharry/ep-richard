class Pod < ActiveRecord::Base
  validates :name, presence: true

  has_one :pod_admin
  has_many :parents
  has_many :comments

  def set_go_live_date
    if !self.go_live_date
      self.go_live_date = Date.today
      self.save
    else
      return false
    end
  end

  def week_number
    pod_go_live_date = Date.parse(self.go_live_date.to_s)
    ((Date.today - pod_go_live_date)/7).to_i
  end

  # TODO: can I use the has_man comments instead?
  def number_of_comments
    comments = []
    Game.all.each do |game|
      comments.push(game.comments_for_pod(self.id))
    end
    comments.count
  end

end
