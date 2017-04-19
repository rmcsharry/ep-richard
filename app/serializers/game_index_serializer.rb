class GameIndexSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :description,
             :image_url,
             :in_default_set,
             :position,
             :eyfs_area,
             :eyfs_goal,
             :has_parent_played
end
