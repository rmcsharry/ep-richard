class Game < ActiveRecord::Base
  validates :name, presence: true
  validates :video_url, presence: true
  validate  :video_url_is_correct
  has_many :comments
  acts_as_list add_new_at: :top
  
  def comments_for_pod(pod_id)
    self.comments.where('pod_id = ?', pod_id).order(created_at: :desc)
  end

  def video_iframeurl
    "//fast.wistia.net/embed/iframe/#{self.video_url.split("/")[-1]}?videoFoam=true&wmode=transparent"
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
        non_default_games = Game.where("in_default_set = false").order("position ASC")
        non_default_games[0, parent.pod.week_number].each do |game|
          game.position = game.position * -1 # the non default games should appear in reverse order, since they get released weekly
        end
      else
        []
      end
    else
      []
    end
  end

  def self.default
    Game.where("in_default_set = true").order("position ASC")
  end

  def self.non_default
    Game.where("in_default_set = false").order("position ASC")
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
      json["thumbnail_url"] = json["thumbnail_url"] + "&image_crop_resized=450x253"
      json["html"]
      json
    rescue JSON::ParserError
      false
    end
  end

  EYFS_AREAS = [
    'Communication and Language',
    'Literacy',
    'Mathemathics',
    'Personal, Social, & Emotional Development',
    'Physical Development',
    'Understanding the world',
  ]
  EYFS_GOALS = [
    'Listening and attention',
    'Understanding',
    'Speaking',
    'Moving and handling',
    'Health and Self-Care',
    'Self-confidence and Self-awareness',
    'Managing feelings and behaviour',
    'Making relationships',
    'Reading',
    'Writing',
    'Numbers',
    'Shape, space and measures',
    'People and communities',
    'The World',
    'Technology',
    'Exploring and using media and materials',
    'Being imaginative'    
  ]

end
