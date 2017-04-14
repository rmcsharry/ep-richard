module Played
  extend ActiveSupport::Concern
  include ActionView::Helpers::TextHelper  

  def get_played_text(pod_id, game_id, week_text)
    log_for_timescale = ParentVisitLog.where(pod_id: pod_id, game_id: game_id)
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
      parents_played += " and #{pluralize(play_count - 2, 'other parent')} have played this #{week_text}game."
    else
      parents_played = nil
    end    
  end
end