class ParentSerializer < ActiveModel::Serializer
  attributes :id, :name, :first_name, :pod_name, :phone, :slug, :pod_latest_comment, :pod_latest_comment_parent_name, :pod_latest_comment_game_name

  def pod_name
    object.pod.name
  end
  
  def pod_latest_comment
    object.pod.latest_comment
  end
  
  # TODO: The pod_latest_comment is an embedded object inside Parent, so it only contains ids for parent and game, hence we need to serialize these properties
  # but is there a better way to do this? How can we get the client to retrieve these properites without it making another server request to get them?
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
end
