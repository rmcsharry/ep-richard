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
    if Rails.env == "production" || Rails.env == "staging"
      account_sid = 'AC38de11026e8717f75248f84136413f7d'
      auth_token = 'f82546484dc3dfc96989f5930a13e508'

      @client = Twilio::REST::Client.new account_sid, auth_token

      body = "Hi #{self.first_name}, you have been invited to use #{pod.name} for free with other parents in your community on EasyPeasy" + 
                  " - an app for parents that sends you fun, simple game ideas to support your child's early development." +
                  " No need to register, just start here: http://play.easypeasyapp.com/#/#{self.slug}/games" +
                  " and we will send you a new game every week."
      
      @client.account.messages.create({
        :from => 'EasyPeasy',
        :to => "+44#{self.phone}",
        :body => body 
      })
    end
  end

  def log_welcome_sms_sent
    self.welcome_sms_sent = true
    self.save
  end

  def first_name
    self.name.split(" ")[0]
  end

  def should_notify?
    return false if !self.pod.go_live_date
    return false if self.pod.week_number == 0
    return false if !Game.non_default[self.pod.week_number - 1]
    return true
  end

  def should_send_new_game_sms?    
    return false if self.last_notification && self.last_notification > Date.today - 7.days
    return true
  end

  def notify
    message = "Hello #{self.first_name}, your new game is now available on EasyPeasy. Open this link to see it: http://play.easypeasyapp.com/#/#{self.slug}/games/"
    if should_notify? && should_send_new_game_sms?
      self.last_notification = Date.today
      send_sms(message) if self.save
      return true
    else
      return false
    end
  end

  def send_weekend_sms
    game = self.pod.current_game
    return false if game.nil?     
    message = "Hi #{self.first_name}, it's the weekend - let's play! http://play.easypeasyapp.com/#/#{self.slug}/game/" + game.id.to_s
    try_to_send(message)
  end       

  def send_did_you_know_fact(date=Date.today)
    game = self.pod.current_game
    return false if game.nil?
    message = "Hi #{self.first_name}, did you know this? - " + game.did_you_know_fact +
              " Try it out with the game " + game.name + " here: " +
              "http://play.easypeasyapp.com/#/#{self.slug}/game/" + game.id.to_s
    # send only if it has been 2 days since the welcome message for the current game was sent 
    try_to_send(message, date, 2)    
  end

  def send_top_tip(date=Date.today)
    game = self.pod.current_game
    return false if game.nil? 
    message = "Hi #{self.first_name}, our top tip for " + game.name + " is: " + game.top_tip + 
              " How did you play the game? Share your thoughts here: " +
              "http://play.easypeasyapp.com/#/#{self.slug}/game/" + game.id.to_s
    # send only if it has been 4 days since the welcome message for the current game was sent 
    try_to_send(message, date, 4)
  end

  def send_sms(message)
    if Rails.env == "production"
      account_sid = 'AC38de11026e8717f75248f84136413f7d'
      auth_token = 'f82546484dc3dfc96989f5930a13e508'
      @client = Twilio::REST::Client.new account_sid, auth_token
      @client.account.messages.create({
        :from => 'EasyPeasy',
        :to => "+44#{self.phone}",
        :body => message
      })
    end
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
        if existing_parent.nil?
          parent = Parent.new(parent_hash)
          if parent.valid?
            parent.pod_id = pod_id
            parent.save
            new_parent_count = new_parent_count + 1
          end
        else
          # TODO: currently do nothing, we need to know what to do if the phone already exists
          # existing_parent.update_attributes(parent_hash)
        end
      end
    end
    return new_parent_count
  end

  private 
  def try_to_send(message, date=nil, num_days=nil)
    if should_notify? && (date.nil? || date == self.last_notification + num_days.days)
      send_sms(message)
      return true
    else
      return false     
    end
  end
  
  def build_welcome_message
    salutation = "Hi #{self.first_name},"
    greeting = "you have been invited"
    body = "to use #{pod.name} for free with other parents in your community on EasyPeasy" + 
                  " - an app for parents that sends you fun, simple game ideas to support your child's early development." +
                  " No need to register, just start here: http://play.easypeasyapp.com/#/#{self.slug}/games" +
                  " and we will send you a new game every week."
    
    if !self.pod.pod_admin.nil?
      if self.pod.pod_admin.name
        greeting = "#{self.pod.pod_admin.name} has invited you"
      else
        greeting = "#{self.pod.pod_admin.preferred_name} has invited you"
      end
    end
    return "#{salutation} #{greeting} #{body}"
  end
  
end
