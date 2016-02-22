class ParentSerializer < ActiveModel::Serializer
  attributes :id, :name, :first_name, :pod_name, :phone, :slug, :pod_latest_comment, :pod_latest_comment_parent_name, :pod_latest_comment_game_name

  def pod_name
    object.pod.name
  end
  
  def pod_latest_comment
    object.pod.latest_comment
  end
  
  def pod_latest_comment_parent_name
    object.pod.latest_comment.parent.name
  end
  
  def pod_latest_comment_game_name
    object.pod.latest_comment.game.name
  end
end
