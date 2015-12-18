# x rails runner lib/tasks/email-pod-admins.rb
puts "\n== Sending out pod admin emails #{Time.now}\n\n"

PodAdmin.all.limit(9).each do |pod_admin|
  if pod_admin.send_analytics_email
    puts "  - SENT EMAIL: #{pod_admin.email}"
  else
    puts "  - SKIPPED EMAIL: #{pod_admin.email}"
  end
end

puts "\n== Finished email pod admin job #{Time.now}\n\n"
