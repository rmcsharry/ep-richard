class SendSms

  def self.call(message, to_phone_number)
    if Rails.env == 'production' || Rails.env == 'staging'
      account_sid = 'AC38de11026e8717f75248f84136413f7d'
      auth_token = 'f82546484dc3dfc96989f5930a13e508'
      @client = Twilio::REST::Client.new account_sid, auth_token
      @client.account.messages.create({
        :from => 'EasyPeasy',
        :to => "+44#{to_phone_number}",
        :body => message
      })
    end
  end

end