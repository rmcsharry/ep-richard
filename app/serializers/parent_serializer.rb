class ParentSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :first_name,
             :pod_name,
             :pod_active,
             :phone,
             :slug,
             :pod_most_recent_comment_notice,
             :first_visit,
             :pod_played_current_game

  def first_visit
    object.parent_visit_logs.count == 0
  end

  def pod_name
    object.pod.name
  end

  def pod_active
    return true if object.pod.inactive_date.nil?
    Date.parse(object.pod.inactive_date.strftime("%F")) > Date.parse(Date.today.strftime("%F"))
  end

  def pod_most_recent_comment_notice
    url = "/#/#{object.slug}/game/"
    object.pod.most_recent_comment_notice(url)
  end

  def call_to_comment
    object.pod.call_to_comment
  end

  def pod_played_current_game
    object.pod.played_current_game
  end
end
