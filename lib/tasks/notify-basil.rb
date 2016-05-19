account_sid = 'AC38de11026e8717f75248f84136413f7d'
auth_token = 'f82546484dc3dfc96989f5930a13e508'

@client = Twilio::REST::Client.new account_sid, auth_token

@client.account.messages.create({
  :from => '+441290211660',
  :to => "+447515337356",
  :body => "Hello. Easypeasy daily notifications have just run."
})

@client.account.messages.create({
  :from => 'EasyPeasy',
  :to => "+447787512225",
  :body => "Hello. Easypeasy daily notifications have just run."
})
