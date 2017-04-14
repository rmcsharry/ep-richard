class Game < ActiveRecord::Base
  include ActionView::Helpers::TextHelper  
  validates :name, presence: true
  validates :video_url, presence: true
  validate  :video_url_is_correct
  has_many :comments
  acts_as_list add_new_at: :top
  
  attr_accessor :has_parent_played # this is only set for a particular parent each time they visit the dashboard (index)

  def parents_played(pod_id)
    log_for_timescale = ParentVisitLog.where(pod_id: pod_id, game_id: self.id)
    parents = []
    log_for_timescale.each do |log|
      parents.append(log.parent_id)
    end
    parents_played = ""
    play_count = 0
    parents.uniq.each do |parent_id|
      play_count += 1
      if play_count < 3
        parents_played += Parent.where(id: parent_id).first.first_name
      end
      if play_count < 2
        parents_played += ", "
      end
    end
    if play_count > 2
      parents_played += " and #{pluralize(play_count - 2, 'other parent')} have played this game."
    else
      parents_played = nil
    end
  end

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
    'Expressive Arts & Design',
    'Literacy',
    'Mathematics',
    'Personal, Social & Emotional Development',
    'Physical Development',
    'Understanding the world',
  ]
  EYFS_GOALS = [
    'Speaking',
    'Self-confidence and Self-awareness',
    'Moving and handling',
    'Managing feelings and behaviour',
    'Health and Self-Care',
    'Listening and attention',
    'Understanding',
    'Being imaginative',
    'Exploring and using media and materials',
    'Making relationships',
    'Numbers',
    'People and communities',
    'Reading',
    'Shape, space and measures',
    'Technology',
    'The World',
    'Writing'
  ]

end
