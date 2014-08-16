class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :image_url, :video_url_mp4, :video_url_webm
end
