class ParentSerializer < ActiveModel::Serializer
  attributes :id, :name, :first_name, :pod_name, :phone, :slug, :pod_lc, :pod_lc_parent_name, :pod_lc_game_name

  def pod_name
    object.pod.name
  end
  
  def pod_lc
    object.pod.latest_comment
  end
  
  def pod_lc_parent_name
    object.pod.latest_comment.parent.name
  end
  
  def pod_lc_game_name
    object.pod.latest_comment.game.name
  end
end
