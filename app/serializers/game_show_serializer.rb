require 'redcarpet'

class GameShowSerializer < ActiveModel::Serializer

  attributes :id,
             :name,
             :description,
             :instructions,
             :parents_played,
             :top_tip,
             :did_you_know_fact,
             :image_url,
             :video_url,
             :video_iframeurl,
             :media_hashed_id,
             :in_default_set,
             :position,
             :created_at
             has_many :comments

  def comments
    if serialization_options[:pod_id]
      object.comments_for_pod(serialization_options[:pod_id])
    else
      object.comments.order(created_at: :desc)
    end
  end
  
  def instructions
    if object.instructions
      renderer = Redcarpet::Render::HTML.new(no_links: true, hard_wrap: true)
      Redcarpet::Markdown.new(renderer).render(object.instructions).html_safe
    end
  end

  def parents_played
    if serialization_options[:pod_id]
      Pod.where(id: serialization_options[:pod_id]).first.parents_played
    end
  end

  def media_hashed_id
    if object.video_url
      object.video_url.split("/")[-1]
    end
  end

end
