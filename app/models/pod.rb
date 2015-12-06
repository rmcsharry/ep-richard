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

  def parents_who_visited(timescale)
    log_for_timescale = ParentVisitLog.where(pod_id: self.id)
    parents = []
    log_for_timescale.each do |log|
      parents.append(log.parent_id)
    end
    return parents.uniq
  end

  def most_popular_games(timescale)
    if timescale == "last_week"
      results = []
      start_date = Date.today - 7.days
      end_date = Date.today
      Game.all.each do |game|
        visits = ParentVisitLog.where(pod_id: self.id, game_id: game.id, created_at: start_date..end_date).count
        results.push({ "game_name" => game.name, "visits" => visits })
      end
      results.sort_by { |k| k["visits"] }.reverse
    elsif timescale == "all_time"
      results = []
      Game.all.each do |game|
        visits = ParentVisitLog.where(pod_id: self.id, game_id: game.id).count
        results.push({ "game_name" => game.name, "visits" => visits })
      end
      results.sort_by { |k| k["visits"] }.reverse
    end
  end

end
