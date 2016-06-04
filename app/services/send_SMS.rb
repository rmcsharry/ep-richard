require 'active_interaction'

class SendSms < ActiveInteraction::Base

  string :sender, default: 'EasyPeasy'
  string :recipient
  string :message_body
  boolean :dev_mode, default: false # set to true to test in dev env
  
  def execute
    if Rails.env == 'production' || Rails.env == 'staging' || dev_mode
      # TODO these should be in env vars, not hard-coded here
      account_sid = 'AC38de11026e8717f75248f84136413f7d'
      auth_token = 'f82546484dc3dfc96989f5930a13e508'
      
      begin
        @client = Twilio::REST::Client.new account_sid, auth_token
        sms = @client.account.messages.create({
          from: sender,
          to: "+44#{recipient}",
          body: message_body
        })
      rescue Twilio::REST::RequestError => e
        errors.add("Code: #{e.code.to_s}.", e.to_s)
      rescue SocketError => e
        errors.add(:network, 'is disconnected. Please check your connection.')
      end
      
      return sms
    end
  end

end