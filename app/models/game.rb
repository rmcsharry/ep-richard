class Game < ActiveRecord::Base
  validates :name, presence: true
  validates :video_url, presence: true
  validate  :video_url_is_correct
  has_many :comments

  def comments_for_pod(pod_id)
    parents = Pod.find(pod_id).parents
    filtered_comments = self.comments.map do |comment|
      comment if parents.include?(comment.parent)
    end
    filtered_comments.compact
  end

  def video_url_is_correct
    unless /https?:\/\/(.+)?(wistia.com|wi.st)\/(medias|embed)\/.*/.match(video_url)
      errors.add(:video_url, "doesn't look correct")
    end
  end

end
