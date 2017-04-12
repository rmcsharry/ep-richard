class ParentSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :first_name,
             :pod_name,
             :pod_active,
             :phone,
             :slug,
             :pod_latest_comment,
             :pod_latest_comment_parent_name,
             :pod_latest_comment_game_name,
             :first_visit,
             :pod_parents_played

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

  def pod_latest_comment
    object.pod.latest_comment
  end

  # TODO:
  # The pod_latest_comment is an embedded object inside Parent, so it only contains ids for parent and game, hence we need to serialize these properties here.
  # Maybe there is a better way to do this? When there are lots of comments and parents, there is no guarantee that the parent or comment is already loaded on the client, so
  # we have to send these embedded at this point. Perhaps it is possible to send a custom embedded object instead?
  def pod_latest_comment_parent_name
    if !object.pod.latest_comment.nil?
      object.pod.latest_comment.parent.name
    end
  end

  def pod_latest_comment_game_name
    if !object.pod.latest_comment.nil?
      object.pod.latest_comment.game.name
    end
  end

  def pod_parents_played
    object.pod.parents_played
  end
end
