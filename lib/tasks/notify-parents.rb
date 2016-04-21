puts "\n== Starting notify job #{Time.now}\n\n"

live_pods = Pod.where("go_live_date IS NOT null")

live_pods.each do |pod|

  puts "  Pod ##{pod.id}: #{pod.name} | #{pod.go_live_date} \n\n"

  pod.parents.each do |parent|
    if parent.notify
      puts "  - SENT WELCOME SMS: #{parent.name} (#{parent.phone}) |  #{parent.last_notification} "
    else
      puts "  - SKIPPED WELCOME SMS: #{parent.name} (#{parent.phone})  |  #{parent.last_notification}"
    end
  
    puts "\n"
  end

end

puts "== Finished notify job #{Time.now}\n\n"
