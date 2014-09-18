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
    if video_url.blank?
      return true
    end

    unless /https?:\/\/(.+)?(wistia.com|wi.st)\/(medias|embed)\/.*/.match(video_url)
      errors.add(:video_url, "doesn't look correct")
    end
  end

  def publish
    unless valid?
      return false
    end

    unless embed_data = getEmbedDataFromVideoURL(video_url)
      errors.add(:video_url, " - An error occured while talking to Wistia. Has the video finished encoding on Wistia? If so, wait a moment and try again.")
      return false
    end

    self.image_url = embed_data["thumbnail_url"]
    self.save
  end

  def self.getExtraGamesForParentSlug(parent_slug)
    if parent = Parent.find_by_slug(parent_slug)
      if parent.pod && parent.pod.go_live_date
        parent = Parent.find_by_slug(parent_slug)
        non_default_games = Game.where("in_default_set = false").order("created_at ASC")
        non_default_games[0, parent.pod.week_number]
      else
        []
      end
    else
      []
    end
  end

  def self.default
    Game.where("in_default_set = true").order("created_at ASC")
  end

  def self.non_default
    Game.where("in_default_set = false").order("created_at ASC")
  end

  private

  def getEmbedDataFromVideoURL(video_url)
    require 'net/http'
    url = URI.parse("http://fast.wistia.com/oembed?url=#{video_url}?videoFoam=true")
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
        http.request(req)
    }
    begin
      json = JSON.parse(res.body)
      json["thumbnail_url"] = json["thumbnail_url"] + "&image_crop_resized=450x450"
      json["html"]
      json
    rescue JSON::ParserError
      false
    end
  end

end
