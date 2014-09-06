class Game < ActiveRecord::Base
  validates :name, presence: true
  validates :video_url, presence: true
  has_many :comments

  def comments_for_pod(pod_id)
    parents = Pod.find(pod_id).parents
    filtered_comments = self.comments.map do |comment|
      comment if parents.include?(comment.parent)
    end
    filtered_comments.compact
  end

end
