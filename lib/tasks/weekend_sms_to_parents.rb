puts "\n== Starting weekend sms job #{Time.now}\n\n"

live_pods = Pod.where("go_live_date IS NOT null")

live_pods.each do |pod|

  puts "  Pod ##{pod.id}: #{pod.name}\n\n"

  pod.parents.each do |parent|
    if parent.send_weekend_sms
      puts "  - SENT WEEKEND SMS #{parent.name} (#{parent.phone})"
    else
      puts "  - SKIPPED: #{parent.name} (#{parent.phone})"
    end
  end
  
end