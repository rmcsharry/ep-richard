class Pod < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include Played

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
    return Game.non_default[self.week_number - 2]
  end

  def current_game
    return nil if !self.week_number
    return Game.non_default[self.week_number - 1]
  end

  def next_game
    return nil if !self.week_number
    return Game.non_default[self.week_number]
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
    allParents = self.parents
    # get the parents who did visit as an array of their ids
    visited = self.parents_who_visited(timescale)
    if !visited.nil?
      non_visitors = parents - visited.keys # array subtraction works here as visited will always contain all or a subset of parents
    else
      non_visitors = parents
    end
    parents_names = []
    if non_visitors.count > 0
      non_visitors[0..2].each do |parent_id|
        parents_names.push(allParents.find(parent_id).name)
      end
      case non_visitors.count
      when 1
          names = "#{parents_names[0]}"
      when 2
          names = "#{parents_names[0]} & #{parents_names[1]}"
      else
          names = "#{parents_names[0]}, #{parents_names[1]} & #{parents_names[2]}"
      end
  end

  if non_visitors.count > 0 && allParents.count > 0
    msg = "We haven't seen <strong>#{names}</strong> lately.
      Could you keep an eye out for them at drop off, pick up, or stay and play?"
  elsif allParents.count > 0 && visited.count > 0
    msg = "Awesome! Your parents are super-engaged, keep it up! Share the good news with members of your team!"
  else
    msg = ""
  end
  return msg.html_safe
  end

  def top_three_visitors
    start_date = Date.today.midnight - 7.days
    end_date = Date.today.midnight
    all_time = false
    log_for_timescale = ParentVisitLog.where(pod_id: self.id, created_at: start_date..end_date).group('parent_id').order('count_parent_id desc').count('parent_id')
    if log_for_timescale.count == 0
      all_time = true
      log_for_timescale = ParentVisitLog.where(pod_id: self.id).group('parent_id').order('count_parent_id desc').count('parent_id')
    end
    # get top 3
    parents = []
    log_for_timescale.keys[0..2].each do |parent_id|
      parent = Parent.where('id = ?', parent_id).first
      parents.push(parent.name) if !parent.nil?
    end
    case parents.count
      when 0
        return nil
      when 1
        names = "#{parents[0]}"
      when 2
        names = "#{parents[0]} & #{parents[1]}"
      when 3
        names = "#{parents[0]}, #{parents[1]} & #{parents[2]}"
    end
    msg = "<strong>#{names}</strong> had the most playdates with EasyPeasy"
    if all_time
      msg += " since your Pod went live."
    else
      msg += " this week."
    end
    return msg.html_safe
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

  def played_current_game
    if !self.current_game
      return nil
    else
      get_played_text(self.id, self.current_game.id, "week's ")
    end
  end

  def most_recent_comment_notice(url)
    comment = self.comments.last
    if comment
      return ("The most recent comment was from <strong>#{comment.parent_name}" +
              "</strong> on <strong>#{comment.created_at.strftime('%d %b %y')}" +
              "</strong> at <strong>#{comment.created_at.strftime('%H:%M')}" +
              "</strong>:<br/><br/><i>#{comment.body}</i>" +
              "<br/><br/>on the game <a href='#{url}#{comment.game.id.to_s}'>" +
              "#{comment.game.name}</a>").html_safe
    else
      if self.next_game && self.week_number > 0
        return "This week's game is out! Be the first to comment!"
      else
        return nil
      end
    end
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
