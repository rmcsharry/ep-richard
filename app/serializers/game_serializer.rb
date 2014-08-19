class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image_url, :video_embed_code
end
