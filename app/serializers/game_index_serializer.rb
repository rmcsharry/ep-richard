class GameIndexSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :description,
             :image_url,
             :in_default_set,
             :position
end
