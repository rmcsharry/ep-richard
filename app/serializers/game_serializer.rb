require 'redcarpet'

class GameSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :instructions, :image_url, :video_embed_code

  def instructions
    if object.instructions
      renderer = Redcarpet::Render::HTML.new(no_links: true, hard_wrap: true)
      Redcarpet::Markdown.new(renderer).render(object.instructions).html_safe
    end
  end

end
