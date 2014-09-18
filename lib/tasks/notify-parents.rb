def send_message(phone, message)
  account_sid = 'AC38de11026e8717f75248f84136413f7d'
  auth_token = 'f82546484dc3dfc96989f5930a13e508'

  @client = Twilio::REST::Client.new account_sid, auth_token

  @client.account.messages.create({
    :from => '+441290211660',
    :to => "07515337356",
    :body => message
  })
end

def notify_parents_for_pod(pod)
  pod.parents.each do |parent|

    message = "Hello #{parent.first_name}, your new game is now available on EasyPeasy. Open this link to see it: http://play.easypeasyapp.com/#/#{parent.slug}/games/"

    if parent.last_notification.blank? || parent.last_notification < Date.today - 6.days
      send_message(parent.phone, message)
      parent.last_notification = Time.now
      parent.save
      puts "#{parent.name} (#{parent.phone}) - sending notification.\n"
    else
      puts "#{parent.name} (#{parent.phone}) had a notification on #{parent.last_notification}, skipping.\n"
    end
  end
end

live_pods = Pod.where.not(go_live_date: nil)

live_pods.each do |pod|

  puts "\n== #{pod.name} at #{Time.now}\n"
  if Game.non_default[pod.week_number]
    notify_parents_for_pod(pod)
  else
    puts "No games remaining, not sending any texts.\n"
  end
  puts "\n"

end
