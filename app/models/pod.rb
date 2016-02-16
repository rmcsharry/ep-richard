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

  def current_game
    non_default_games = Game.where("in_default_set = false").order("position ASC")
    next_game = non_default_games[self.week_number-1]
    return next_game.name if next_game
  end

  def next_game
    non_default_games = Game.where("in_default_set = false").order("position ASC")
    next_game = non_default_games[self.week_number]
    if next_game
      return next_game.name
    else
      return nil
    end
  end

  def parents_who_visited(timescale)
    if timescale == "last_week"
      start_date = Date.today.midnight - 7.days
      end_date = Date.today.midnight
      log_for_timescale = ParentVisitLog.where(pod_id: self.id, created_at: start_date..end_date)
    elsif timescale == "all_time"
      log_for_timescale = ParentVisitLog.where(pod_id: self.id)
    end
    parents = []
    log_for_timescale.each do |log|
      parents.append(log.parent_id)
    end
    return parents.uniq
  end 
  
  def parents_who_did_not_visit(timescale)
    # if no parents visited, we will just return all of them
    parents = self.parents.ids

    # get the parents who did visit
    visited = self.parents_who_visited(timescale)
    if !visited.nil?
      return parents - visited # array subtraction works here as visited will always contain all or a subset of parents
    end
  end

  def most_popular_games(timescale)
    if timescale == "last_week"
      start_date = Date.today.midnight - 7.days
      end_date = Date.today.midnight
      results = []
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

  def comments_last_week
    start_date = Date.today.midnight - 7.days
    end_date = Date.today.midnight
    Comment.where(pod_id: self.id, created_at: start_date..end_date)
  end

  def most_commented_games(timescale)
    if timescale == "last_week"
      start_date = Date.today.midnight - 7.days
      end_date = Date.today.midnight
      results = []
      Game.all.each do |game|
        comments_for_game = Comment.where(pod_id: self.id, game_id: game.id, created_at: start_date..end_date).count
        results.push({ "game_name" => game.name, "comments" => comments_for_game })
      end
      results.sort_by { |k| k["comments"] }.reverse
    end
  end

  def most_chatty_parents(timescale)
    if timescale == "last_week"
      start_date = Date.today.midnight - 7.days
      end_date = Date.today.midnight
      results = []
      Parent.all.each do |parent|
        comments_for_parent = Comment.where(pod_id: self.id, parent_id: parent.id, created_at: start_date..end_date).count
        results.push({ "parent_name" => parent.name, "comments" => comments_for_parent })
      end
      results.sort_by { |k| k["comments"] }.reverse
    end
  end

end
