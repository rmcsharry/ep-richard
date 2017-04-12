class Pod < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  validates :name, presence: true

  has_one :pod_admin
  has_many :parents
  has_many :comments

  accepts_nested_attributes_for :parents, allow_destroy: true

  def set_go_live_date
    if !self.go_live_date
      self.go_live_date = Date.today
      self.save
    else
      return false
    end
  end

  def week_number
    return nil if !self.go_live_date
    pod_go_live_date = Date.parse(self.go_live_date.to_s)
    ((Date.today - pod_go_live_date)/7).to_i
  end

  def last_week_game
    return nil if self.week_number == 1
    last_week_game = Game.non_default[self.week_number - 2]
    if last_week_game
      return last_week_game
    else
      return nil
    end
  end

  def current_game
    return nil if !self.week_number
    return Game.non_default[self.week_number - 1]
  end

  def next_game
    next_game = Game.non_default[self.week_number]
    if next_game
      return next_game
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
    # create a hash of parent_id and number of visits
    parent_visits = Hash.new
    parents.uniq.each do |parent_id|
      parent_visits.store(parent_id, parents.count(parent_id))
    end
    return parent_visits.sort_by(&:last).reverse.to_h # sort in reverse order of number of visits
  end

  def parents_who_did_not_visit(timescale)
    # if no parents visited, we will just return all of them
    parents = self.parents.ids

    # get the parents who did visit as an array of their ids
    visited = self.parents_who_visited(timescale).keys
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

  def parents_played
    if !self.current_game
      return nil
    else
      start_date = Date.today.midnight - 7.days
      end_date = Date.today.midnight

      log_for_timescale = ParentVisitLog.where(pod_id: self.id, game_id: self.current_game.id, created_at: start_date..end_date)
      parents = []
      log_for_timescale.each do |log|
        parents.append(log.parent_id)
      end
      parents_played = ""
      play_count = 0
      parents.uniq.each do |parent_id|
        play_count += 1
        if play_count < 3
          parents_played += Parent.where(id: parent_id).first.first_name
        end
        if play_count < 2
          parents_played += ", "
        end
      end
      if play_count > 2
        parents_played += " and #{pluralize(play_count - 2, 'other parent')} have played this weeks game."
      else
        parents_played = nil
      end
    end
  end

  def latest_comment
    self.comments.last
  end

  def days_left
    days = (Date.parse(self.inactive_date.strftime("%F")) - Date.parse(Date.today.strftime("%F"))).to_i unless self.inactive_date.nil?
    return 0 if days < 0
    return days
  end

  def is_active?
    return true if (self.inactive_date.blank? || self.days_left > 0) # if inactive_date is blank, we don't care about trial days left, the pod is active
    return false
  end

  def is_in_trial?
    return true if self.inactive_date && self.days_left > 0 && self.days_left < 15
    return false
  end

  def should_notify?
    return false if !self.is_active?
    return false if !self.week_number || self.week_number == 0
    return false if self.week_number > (Game.non_default.count + 1)
    return true
  end
end
