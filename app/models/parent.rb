class Parent < ActiveRecord::Base
  require 'csv'

  validates :name, presence: true
  validates :phone, presence: true
  # validates :phone, uniqueness: true
  validate :phone_format
  before_create :set_slug

  belongs_to :pod
  has_many :comments, dependent: :destroy
  has_many :parent_visit_logs, dependent: :destroy

  def set_slug
    if self.slug.nil?
      self.slug = SecureRandom.urlsafe_base64(5)
    end
  end

  def phone_format
    if /^07\d{9}$/.match(phone)
      return true
    else
      errors.add(:phone, "should be 11 digits and start 07")
    end
  end

  def send_welcome_sms
    outcome = SendSms.run(message_body: build_welcome_message, recipient: self.phone)
    if outcome.valid?
      self.welcome_sms_sent = true
      self.save
    else
      outcome.errors.each do |k,v|
        self.errors.add(:base, "#{k} #{v}") # use :base since these errors are not related to Parent attributes
      end
    end
  end

  def first_name
    self.name.split(" ")[0]
  end

  def should_notify?
    return false if !self.pod.current_game # don't send if there is no game this week
    return self.pod.should_notify?
  end

  def should_send_new_game_sms?
    return false if self.last_notification == Date.today
    return false if self.pod.go_live_date.wday != Date.today.wday
    return true
  end

  def should_send_additional_sms?(date, num_days)
    return true if self.last_notification && date == self.last_notification + num_days.days
    return false
  end

  def notify
    if should_notify? && should_send_new_game_sms?
      self.last_notification = Date.today
      message = "Hello #{self.first_name}, your new game is now available on EasyPeasy. Open this link to see it: http://play.easypeasyapp.com/#/#{self.slug}/games/"
      try_to_send(message) if self.save
    else
      return false
    end
  end

  def send_weekend_sms
    if should_notify? && self.pod.week_number < 7
      game = self.pod.current_game
      message = "Hi #{self.first_name}, it's the weekend - let's play! http://play.easypeasyapp.com/#/#{self.slug}/game/" + game.id.to_s
      try_to_send(message)
    else
      return false
    end
  end

  def send_did_you_know_fact(date=Date.today)
    if should_notify? && should_send_additional_sms?(date, 2) && self.pod.week_number < 4
      game = self.pod.current_game
      message = "Hi #{self.first_name}, did you know this? - " + game.did_you_know_fact +
                " Try it out with the game " + game.name + " here: " +
                "http://play.easypeasyapp.com/#/#{self.slug}/game/" + game.id.to_s
      # send only if it has been 2 days since the notify sms for this weeks game was sent
      try_to_send(message)
    else
      return false
    end
  end

  def send_top_tip(date=Date.today)
    if should_notify? && should_send_additional_sms?(date, 4) && self.pod.week_number < 10
      game = self.pod.current_game
      message = "Hi #{self.first_name}, our top tip for " + game.name + " is: " + game.top_tip +
                " How did you play the game? Share your thoughts here: " +
                "http://play.easypeasyapp.com/#/#{self.slug}/game/" + game.id.to_s
      # send only if it has been 4 days since the notify sms for this weeks game was sent
      try_to_send(message)
    else
      return false
    end
  end

  def call_to_comment
    pod.call_to_comment
  end

  def self.not_commented(pod)
    parents = Parent.where(pod: pod)
    not_commented = []
    parents.each do |p|
      not_commented.append(p) if p.comments.count == 0
    end
    not_commented
  end

  def self.import(file, pod_id)
    new_parent_count = 0
    if !file.nil?
      CSV.foreach(file.path, headers: true, :header_converters => lambda { |h| h.try(:downcase) }) do |row|

        parent_hash = row.to_hash
        existing_parent = Parent.where(phone: parent_hash["phone"]).first

        # TODO: need to know what feedback to give to the user for error, success and existing records
        # if existing_parent.nil?
          parent = Parent.new(parent_hash)
          if parent.valid?
            parent.pod_id = pod_id
            parent.save
            new_parent_count = new_parent_count + 1
          end
        # else
          # TODO: currently do nothing, we need to know what to do if the phone already exists
          # existing_parent.update_attributes(parent_hash)
        # end
      end
    end
    return new_parent_count
  end

  def mark_games_played(games)
    visits = ParentVisitLog.where(parent_id: self.id).group('game_id').select('game_id').distinct.all
    games_played = []
    visits.each do |visit|
      games_played.push(visit.game_id) if visit.game_id
    end
    games.each do |game|
      if games_played.include? game.id
        game.has_parent_played = true 
      else
        game.has_parent_played = false
      end
    end
  end
  
  private

  def try_to_send(message)
    outcome = SendSms.run(message_body: message, recipient: self.phone)
    return true if outcome.valid?
    return false
  end

  def build_welcome_message
    salutation = "Hi #{self.first_name},"
    body = "to join #{pod.name}'s Pod for free with other parents in your community on EasyPeasy" +
                  " - an app that sends you fun, simple game ideas to support your child's early development." +
                  " No need to register, just start here: http://play.easypeasyapp.com/#/#{self.slug}/games"

    inviter = "#{self.pod.pod_admin.try(:name)}"
    inviter = "#{self.pod.pod_admin.try(:preferred_name)}" unless inviter.present?
    if inviter.present?
      return "#{salutation} #{inviter} invites you #{body}"
    else
      return "#{salutation} you are invited #{body}"
    end

  end

end
