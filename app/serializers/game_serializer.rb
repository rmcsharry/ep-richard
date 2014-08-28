class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :instructions, :image_url, :video_embed_code
end
