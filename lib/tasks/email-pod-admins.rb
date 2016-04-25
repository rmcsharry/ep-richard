# x rails runner lib/tasks/email-pod-admins.rb
puts "\n== Sending out pod admin emails #{Time.now}\n\n"

pod_admins = PodAdmin.where("pod_id IS NOT null")

pod_admins.all.each do |pod_admin|
  if pod_admin.send_analytics_email
    puts "  - SENT EMAIL: #{pod_admin.email}"
  else
    puts "  - SKIPPED EMAIL: #{pod_admin.email}"
  end
  
  if pod_admin.send_trial_reminder_email
    puts "  - SENT TRIAL REMINDER EMAIL: #{pod_admin.email}"
  else
    puts "  - SKIPPED TRIAL REMINDER EMAIL: #{pod_admin.email}"
  end

  if pod_admin.send_trial_reminder_email('Jen')
    puts "  - SENT TRIAL REMINDER EMAIL COPY: Jen - hello@easypeasyapp.com"
  else
    puts "  - SKIPPED TRIAL REMINDER COPY: Jen - hello@easypeasyapp.com"
  end  
end

puts "\n== Finished email pod admin job #{Time.now}\n\n"
