account_sid = 'AC38de11026e8717f75248f84136413f7d'
auth_token = 'f82546484dc3dfc96989f5930a13e508'

@client = Twilio::REST::Client.new account_sid, auth_token

@client.account.messages.create({
  :from => '+441290211660',
  :to => "07515337356",
  :body => "This is a test message from EasyPeasy."
})
